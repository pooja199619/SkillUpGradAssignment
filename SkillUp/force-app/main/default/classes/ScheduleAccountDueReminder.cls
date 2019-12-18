global class ScheduleAccountDueReminder implements Schedulable{

    global void execute(System.SchedulableContext ctx){
        
 		AccountDue accountLastMonthDueJob = new AccountDue();
        Database.executeBatch(accountLastMonthDueJob);
        
        String scheduleTime = '0 0 0 30 1/1 ? *';
		System.schedule('ScheduledJobForLastMonthDueAcknowledgement', scheduleTime , new ScheduleAccountDueReminder());
        
    }
}