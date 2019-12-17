public class TraineeInsertViaLWC {
 @AuraEnabled 
    public static void saveContact(Contact con){
        insert con;
    }   
}