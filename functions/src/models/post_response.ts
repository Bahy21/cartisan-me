import { PostModel } from "./post_model";
import { UserModel } from "./user_model";

export class PostResponse{
    post: PostModel;
    user: UserModel;
    constructor({post, user}: {post: PostModel, user: UserModel}){
        this.post = post;
        this.user = user;
    }
    toMap(){
        return {
            'post': this.post.toMap(),
            'user': this.user.toMap()
        }
    }
}