public class CourseHandler 
{
      @future(callout=True)
 public static void getCourseStatusAndUpdateTrainingStatus(Set<Id> setOfCourseId)
 {
        try
        {
			system.debug('Set of course '+setOfCourseId);
            map<Id,String> traineeIdmap = new map<Id,String>();
            Set<Id> traineeIdset = new Set<Id>();
             List<Attachment> attach_List = new List<Attachment>();
            List<Attachment> attachment_List = NEW List<Attachment>();
            List<Course__c> listOfCourse = [Select id,Is_Course_Completed__c from Course__c Where Id in:setOfCourseId];
            List<Trainee__c> traineeList = [SELECT Id,Name,Course_Status__c,Course__c,Completion_Date__c,Email__c 
                                            FROM Trainee__c WHERE Course__r.Id IN: setOfCourseId];
            System.debug('List Of trainee --- '+ traineeList);
            if(traineeList.size()>0 && listOfCourse.size()>0)
            {
                    for(Course__c courseobj : listOfCourse)
                    {
                      for(Trainee__c traineeObj : traineeList)
                      {
                        if(traineeObj.Course__c==courseobj.Id && courseobj.Is_Course_Completed__c==TRUE)
                        {
                            traineeObj.Course_Status__c='Completed';
                            traineeobj.Completion_Date__c=system.today();
                            
                        }
                          // Uncomment when trainee course completion date set to blank mannually
                        /*else if(traineeObj.Course__c==courseobj.Id && courseobj.Is_Course_Completed__c==FALSE){
                            traineeObj.Course_Status__c='In Progress'; 
                            traineeobj.Completion_Date__c=null;
                        }  */
                    }
                }
               if(traineeList.size()>0)
               {
                system.debug('trainee '+traineeList);
                Update traineeList;
           		}
                for(Trainee__c trainedata : traineeList)
                {
                    traineeIdset.add(trainedata.id);
                }
                for(Attachment attach : [Select Id,ParentId,description from Attachment where ParentId In : traineeIdset])
                {
                   traineeIdmap.put(attach.Id, attach.Name);
                }
                for(Trainee__c trainedata : traineeList)
                {
                            if((trainedata.Course_Status__c=='Completed') && (!traineeIdmap.containsKey(trainedata.Id)))
                            {
                                //trainedata.Completion_Date__c=system.today();
                                PageReference pageRef = new PageReference('/apex/SaveAndMailCertificate');
                                pageRef.getParameters().put('id',trainedata.Id);
                                //pageRef.setRedirect(true);
                                blob body = pageRef.getContentAsPDF();
                                string filename = trainedata.Name +' Certificate ';
                                Attachment attach_file = new Attachment();
                                attach_file.isPrivate = false;
                                attach_file.Description=trainedata.id+'  '+trainedata.Course__c;
                                attach_file.body = body;
                                attach_file.ParentId = trainedata.Id;
                                attach_file.Name = filename;
                                attach_file.ContentType='application/pdf';
                                attach_List.add(attach_file);
                                
                               // sending mail
                              /* Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
							   Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment(); 
                               attach.setFileName(filename);
                               attach.setBody(body);
                               semail.setSubject(trainedata.Course__c+' Course Completed.');
                               String[] Emailid=new String[]{trainedata.Email__c};
                               semail.setToAddresses(Emailid); 
                               semail.setPlainTextBody('Please find your training Completion certificate.');
                               semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
							   Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
							*/
                   		 }
                    
                    }
                
                if(attach_List.size()>0)
                {
                    for(Attachment acc:attach_List)
                    system.debug('trainee attachment '+acc.Name);
                    Insert attach_List;
             	}
             }
        }                             
        Catch(Exception ex)
        {
            System.debug(ex.getLineNumber());
            System.debug(ex.getMessage());
        }
    }
}