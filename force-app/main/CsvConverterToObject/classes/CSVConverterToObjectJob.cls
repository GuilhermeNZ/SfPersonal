/**
 * @description: This job is responsible to start the CSVConverterToObject process
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class CSVConverterToObjectJob implements Schedulable {
    
    ContentVersionRepository contentVersionRepository;

    private Integer minutes;

    public CSVConverterToObjectJob( Integer minutes ) {
        this.contentVersionRepository = new ContentVersionRepository();

        this.minutes = minutes;
    }

    public void execute (SchedulableContext context) {

        List<ContentVersion> contentVersionInExecutionProcess = this.contentVersionRepository.findByIsExecuting();
        if( !contentVersionInExecutionProcess.isEmpty() ){
            this.finish();
            return;
        } 

        Database.executeBatch( new CSVConverterToObjectBatch() );
        this.finish();
    }

    public void finish () {
        Logger.log('CSVConverterToObjectJob finished');
        start(this.minutes);
    } 

    public static void start( Integer minutes ) {
        abort();
        new ScheduleHelper().scheduleIntoNextMinutes( new CSVConverterToObjectJob(minutes), minutes  );
    }

    public static void abort() {
        new ScheduleHelper().abort('CSVConverterToObjectJob');
    }

}