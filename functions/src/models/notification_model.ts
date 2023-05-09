import { NotificationType } from "./enums";

export class NotificationModel {
    ownerId: string;
    userId: string;
    type: NotificationType;
    timestamp: number;
    username: string;
    userProfileImg: string;
    constructor({ownerId,userId,timestamp,username,type,userProfileImg}:{
      ownerId: string,
      userId: string,
      timestamp: number,
      username: string,
      type: NotificationType;
      userProfileImg: string;
    }
    ) {
      this.ownerId = ownerId;
      this.userId = userId;
      this.timestamp = timestamp;
      this.username = username;
      this.type = type;
    }

    toMap(){
        return {
            ownerId: this.ownerId,
            userId: this.userId,
            timestamp: this.timestamp,
            username: this.username,
            type: this.type,
            userProfileImg: this.userProfileImg
        }
    }
  }