import { LightningElement, track, api } from 'lwc';
import createTraineeRecord from '@salesforce/apex/checkCRUDForLWC.createTraineeRecord'
export default class SaveButton extends LightningElement {
    @track selectedCourseId;
    @api selectedRecordId;
    @track error;
    @api recordId;
    @track getContactId;
  
    handleClick(event) {
        this.selectedCourseId = this.selectedRecordId.Id;
        //this.getContactId = this.recordId.Id;
        window.console.log(this.selectedCourseId);
        window.console.log(this.recordId);
        createTraineeRecord({courseId: this.selectedCourseId , contactId: this.recordId})
      .then(result => { this.messageFromImperative = result })
      .catch(error => { this.errorFromImperative = error })
  }
    
}