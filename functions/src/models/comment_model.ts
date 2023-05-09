export class CommentModel{
    username:string;
    userId:string;
    url: string;
    comment:string;
    timestamp: number;
    commentId: string;
    constructor(
        {username,userId,url,comment,timestamp,commentId}:
        {
            username:string,
            userId:string,
            url:string,
            comment:string,
            timestamp:number,
            commentId: string
        }
    ){
        this.username = username;
        this.userId = userId;
        this.url = url;
        this.comment = comment;
        this.timestamp = timestamp;
        this.commentId = commentId;
    }
    toMap(){
        return {
            username: this.username,
            userId: this.userId,
            url: this.url,
            comment: this.comment,
            timestamp: this.timestamp,
            commentId: this.comment
        }
    }
    
}