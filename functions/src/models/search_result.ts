export class SearchResult{
    postId: string;
    imageUrl: string;
    constructor({postId, imageUrl}:{postId:string, imageUrl:string}){
        this.postId = postId;
        this.imageUrl = imageUrl;
    }
}