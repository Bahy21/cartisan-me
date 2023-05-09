export class ReportModel{
    reportId: string;
    reportedUsersId: string;
    flaggedBy: string;
    reportedFor: string;
    isGroup: boolean;
    postId: string;
    messageId: string;
    constructor(
        {reportId, reportedUsersId, flaggedBy, isGroup, reportedFor, postId, messageId}:{
            reportId: string,
            reportedUsersId: string,
            flaggedBy: string,
            reportedFor: string,
            isGroup: boolean,
            postId: string,
            messageId: string
        } 
    ){
        this.reportId = reportId;
        this.reportedUsersId = reportedUsersId;
        this.flaggedBy = flaggedBy;
        this.reportedFor = reportedFor;
        this.isGroup = isGroup;
        this.postId = postId;
        this.messageId = messageId;
    }

    toMap(){
        return {
            reportID: this.reportId,
            reportedUsersId: this.reportedUsersId,
            flaggedBy: this.flaggedBy,
            reportedFor: this.reportedFor,
            isGroup: this.isGroup,
            postId: this.postId,
            messageId: this.messageId,
            timestamp: Date.now(),
            actionTaken: false,
        }
    }
}