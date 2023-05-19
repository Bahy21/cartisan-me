import { NotificationType } from "./enums";

export class NotificationModel {
    notificationId: string;
    ownerId: string;
    userId: string;
    type: NotificationType;
    timestamp: number;
    username: string;
    userProfileImg: string;
    constructor({notificationId,ownerId,userId,timestamp,username,type,userProfileImg}:{
      notificationId: string,
      ownerId: string,
      userId: string,
      timestamp: number,
      username: string,
      type: NotificationType;
      userProfileImg: string;
    }
    ) {
      this.notificationId = notificationId;
      this.ownerId = ownerId;
      this.userId = userId;
      this.timestamp = timestamp;
      this.username = username;
      this.type = type;
      this.userProfileImg = userProfileImg;
    }

    toMap(){
        return {
            notificationId: this.notificationId,
            ownerId: this.ownerId,
            userId: this.userId,
            timestamp: this.timestamp,
            username: this.username,
            type: this.type,
            userProfileImg: this.userProfileImg
        }
    }
  }