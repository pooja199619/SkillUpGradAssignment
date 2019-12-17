@isTest 
private class ScheduleAccountDueReminderTest
{ 
    // Dummy CRON expression: current time . 
    // Because this is a test, job executes 
	// immediately after Test.stopTest(). 
    public static String CRON_EXP = '0 10 12 16 12 ? 2019'; 
    static testmethod void testScheduledJob() 
    { 
        // Create Test Data Test.startTest(); 
       // Schedule the test job 
       String jobId = System.schedule('ScheduledJobForLastMonthDueAcknowledgement123456', CRON_EXP, new ScheduleAccountDueReminder()); 
        // Key thing to Note: Stopping the test will run the job synchronously 
        Test.stopTest(); 
    // Now that the scheduled job has executed, 
    // Use System.assertEquals to confirm test success 
    } 
}