export class ReviewModel {
    reviewId: string;
    reviewText: string;
    rating: number;
    reviewerName: string;
    reviewerId: string;
    timestamp : number;
    constructor({reviewText, rating, reviewerName, reviewerId, reviewId, timestamp} :{
        reviewId: string,
        reviewText: string,
        rating: number,
        reviewerName: string,
        reviewerId: string,
        timestamp: number,
    }){
        this.reviewId = reviewId;
        this.reviewText = reviewText;
        this.rating = rating;
        this.reviewerName = reviewerName;
        this.reviewerId = reviewerId;
        this.timestamp = timestamp;
    }

    toMap(){
        return {
            reviewID: this.reviewId,
            reviewText: this.reviewText,
            rating: this.rating,
            reviewerName: this.reviewerName,
            reviewerId: this.reviewerId,
            timestamp: this.timestamp,
        }
    }

    
}