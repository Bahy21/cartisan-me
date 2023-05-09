import { faker } from "@faker-js/faker";
import * as functions from "firebase-functions";
import { firestore } from "firebase-admin";
import * as db from "./database.js";
import { UserModel } from "../models/user_model.js";
import { PostModel } from "../models/post_model.js";
import { CommentModel } from "../models/comment_model.js";
import { DeliveryOptions } from "../models/enums.js";
import { DocumentSnapshot } from "firebase-admin/firestore";
import { ReviewModel } from "../models/review_model.js";
function log(message: string) { functions.logger.log(`FakeDataPopulator   |   ${message}`); };
// function logObject(obj: any) {functions.logger.log("Object logged: ", obj)};
export class FakeDataPopulator {
  maxUsers = 5;
  maxPostsPerUser = 5;
  userList: UserModel[] = <UserModel[]>[];
  database: firestore.Firestore;
  constructor(firestoreDatabase: firestore.Firestore,) {
    this.database = firestoreDatabase;
  }

  async generateFakeUsers() {
    const full: DocumentSnapshot = await this.database.collection("filled").doc("filled").get();

    if (full.exists && full.data().filled) {
      log("database is already filled with fake data");
      return;
    }
    log("generating fake users");
    for (let count = 1; count <= this.maxUsers; count++) {
      const newUser = new UserModel(
        {
          id: faker.datatype.uuid(),
          username: faker.internet.userName(),
          url: faker.image.avatar(),
          email: faker.internet.email()
        }
      );
      this.userList.push(newUser);
      await this.createUserDocument(newUser.id, newUser);
      await this.generateFakePosts({ userId: newUser.id, username: newUser.username });
    };
  }

  async generateFakePosts({ userId, username }: { userId: string, username: string }) {
    log(`generating fake product for user ${userId}`);
    for (let i = 1; i <= this.maxPostsPerUser; i++) {
      const options = this.generateOptions(5);
      const newPost = new PostModel(
        {
          postId: faker.datatype.uuid(),
          ownerId: userId,
          username: username,
          description: faker.commerce.productDescription(),
          productName: faker.commerce.product(),
          brand: faker.company.name(),
          variants: options,
          price: parseInt(faker.commerce.price()),
          location: faker.address.streetAddress(),
          rating: faker.datatype.number({ max: 5, min: 1 }),
          reviewCount: 0,
          likesCount: 0,
          commentCount: 0,
          images: this.getImages(3),
          selectedVariant: options[0],
          deliveryOptions: DeliveryOptions.pickup,
          quantity: faker.datatype.number({ max: 5, min: 1 }),
          isProductInStock: true,
          archived: false,
          sellCount: faker.datatype.number({ max: 10, min: 3 }),
          timestamp: Date.now()
          
        }
      );
      newPost.likesCount = await this.generateLikes(newPost.postId);
      newPost.commentCount = await this.generateComments(newPost.postId);
      newPost.reviewCount =  await this.generateReviewers(newPost.postId);
      await this.createUserPost(newPost.ownerId, newPost.postId, newPost);
    }
  }

  private generateOptions(count: number): string[] {
    let options = <string[]>[];
    for (let i = 0; i < count; i++) {
      options.push(faker.commerce.productMaterial());
    }
    return options;
  }

  private async generateLikes(postId: string) {
    try {
      const likes: Map<string, boolean> = new Map();
      for (const liker of this.userList) {
        if (Math.random() > 0.5) {
          likes.set(liker.id, true);
        }
      }
      for (const [key, _] of likes.entries()) {
        await db.likesCollection(postId).doc(key).set({ "timestamp": Date.now() });
      }
      return likes.size;
    } catch (error) {
      console.log("error generating likes");
      console.log(error);
      return 0;
    }
  }


  private async generateComments(postId: string) {
    try {
      let comments: Map<any, any> = new Map();
      for (var commenter of this.userList) {
        if (Math.random() > 0.5) {
          var commentId=faker.datatype.uuid();
          comments.set(commentId, new CommentModel({
            userId: commenter.id,
            username: commenter.username,
            url: commenter.url,
            comment: faker.lorem.sentence(faker.datatype.number({ max: 20, min: 10 })),
            timestamp: Date.now(),
            commentId: commentId
          }));
        }
      }
      for (const [key, value] of comments.entries())  {
        await db.commentsCollection(postId).doc(key).set(value.toMap());
      }
      return comments.size;
    } catch (error) {
      log("error generating comments");
      log(error);
      return 0;
    }
  }
  private getImages(count: number): string[] {
    let images = <string[]>[]
    for (let i = 0; i < count; i++) {
      images.push(`https://placekitten.com/${faker.datatype.number({min: 200, max:1000})}/${faker.datatype.number({min: 200, max:1000})}`)
    }
    return images;
  }
  private async generateReviewers(postId: string) {
    try {
      let reviews = new Map();
      for (var reviewer of this.userList) {
        if (Math.random() > 0.5) {
          const reviewId = faker.datatype.uuid();
          reviews.set(reviewId, new ReviewModel({
            reviewId: reviewId,
            reviewerId: reviewer.id,
            reviewerName: reviewer.username,
            rating: faker.datatype.number({ max: 5, min: 1 }),
            reviewText: faker.lorem.sentence(faker.datatype.number({ max: 20, min: 10 })),
          }));
        }
        for (const [key, value] of reviews.entries()) {
          await db.reviewCollection(postId).doc(key).set(value.toMap());
        }
      }
      return reviews.size;
    } catch (error) {
      log("error in generateReviewers");
      log(error);
      return 0;
    }
  }

  private async createUserDocument(userId: string, user: UserModel): Promise<void> {
    await this.generateUserDocument(userId).set(user.toMap());
  }

  private async createUserPost(userId: string, postId: string, post: PostModel): Promise<void> {
    try {
      await this.generatePostDocument(postId).set(post.toMap());
    } catch (error) {
      functions.logger.log(error);
    }
  }

  private generatePostDocument(postId: string): firestore.DocumentReference {
    return db.postsCollection.doc(postId);
  }
  private generateUserDocument(userId: string): firestore.DocumentReference {
    return db.userCollection.doc(userId);
  }
}

