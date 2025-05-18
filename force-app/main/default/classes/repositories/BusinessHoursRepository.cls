/**
 * @description: Class to provide stored BusinessHours collections
 * @author: Guilherme Zwipp
 */
public virtual class BusinessHoursRepository {

    private static BusinessHoursRepository instance = null;

    public static BusinessHoursRepository getInstance(){
        if( instance == null ) instance = new BusinessHoursRepository();
        return instance;
    }

    protected BusinessHoursRepository(){}
    
    public virtual BusinessHours findDefault() {
        return [
            SELECT 
                Id 
            FROM 
                BusinessHours 
            WHERE IsDefault = true Limit 1
        ];
    }

}