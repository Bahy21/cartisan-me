export class ReviewModel {
    reviewId: string;
    reviewText: string;
    rating: number;
    reviewerName: string;
    reviewerId: string;
    timestamp = Date.now();
    constructor({reviewText, rating, reviewerName, reviewerId, reviewId} :{
        reviewId: string,
        reviewText: string,
        rating: number,
        reviewerName: string,
        reviewerId: string,
    }){
        this.reviewId = reviewId;
        this.reviewText = reviewText;
        this.rating = rating;
        this.reviewerName = reviewerName;
        this.reviewerId = reviewerId;
    }

    toMap(){
        return {
            reviewID: this.reviewId,
            reviewText: this.reviewText,
            dateTime: this.timestamp,
            rating: this.rating,
            reviewerName: this.reviewerName,
            reviewerID: this.reviewerId,
        }
    }

    
}