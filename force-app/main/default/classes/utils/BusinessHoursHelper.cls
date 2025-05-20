/**
 * @description: Class to help on BusinessHours Functions
 * @author: Guilherme Delgado - Everymind
 */
public with sharing class BusinessHoursHelper {

    private static BusinessHoursHelper instance = null;

    public static BusinessHoursHelper getInstance() {
        if( instance == null ) instance = new BusinessHoursHelper();
        return instance;
    }

    private BusinessHoursHelper(){}

    public Decimal getTimeIntervalMinutes( DateTime startDate, DateTime endDate, BusinessHours defaultBusinessHours ) {
        if( startDate == null || endDate == null ) return 0;

        if( defaultBusinessHours == null ) throw new BusinessHoursException( 'Nenhum registro de BusinessHours default encontrado!' );

        return( BusinessHours.diff( defaultBusinessHours.Id, startDate, endDate ) / ( 60*1000 ) );
    }

    public class BusinessHoursException extends Exception {}

}