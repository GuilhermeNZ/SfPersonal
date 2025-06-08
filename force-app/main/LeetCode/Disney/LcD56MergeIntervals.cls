/*
 * @author: Guilherme Zwipp
*/
public with sharing class LcD56MergeIntervals {

    //Resolution time: 45 min
    
    public static List<List<Integer>> resolutionMerge( List<List<Integer>> intervals ) {

        List<List<Integer>> sortedIntervals = sortIntervals( intervals );

        List<List<Integer>> result = new List<List<Integer>>();

        Integer startValue = null;
        Integer endValue = null;

        for( List<Integer> sortedInterval : sortedIntervals ) {

            if( startValue == null && endValue == null ) {
                startValue = sortedInterval[0];
                endValue = sortedInterval[1];
                continue;
            }

            if( sortedInterval[0] >= startValue && sortedInterval[0] <= endValue ) {
                if( sortedInterval[1] > endValue ) endValue = sortedInterval[1];
                continue;
            }

            result.add( new List<Integer>{startValue,endValue} );
            startValue = sortedInterval[0];
            endValue = sortedInterval[1];
        }

        result.add( new List<Integer>{startValue,endValue} );

        return result;
    }

    private static List<List<Integer>> sortIntervals( List<List<Integer>> intervalsToSort ) {

        List<List<Integer>> sortedIntervals = new List<List<Integer>>();

        List<Integer> previousInterval = null;
        Boolean isIntervalsSorted = true;

        for( List<Integer> intervalToSort : intervalsToSort ) {

            if( previousInterval == null ) {
                previousInterval = intervalToSort;
                sortedIntervals.add( previousInterval );
                continue;
            }

            if( previousInterval[0] > intervalToSort[0] ) {
                sortedIntervals[sortedIntervals.indexOf( previousInterval )] = intervalToSort;
                sortedIntervals.add( previousInterval );

                isIntervalsSorted = false;
                previousInterval = null;
                continue;
            }

            sortedIntervals.add( intervalToSort );
            previousInterval = intervalToSort;

        }
        
        if( !isIntervalsSorted ) return sortIntervals( sortedIntervals );

        return sortedIntervals;
    }

    // Example 1:
    // List<List<Integer>> intervals = new List<List<Integer>>();
    // intervals.add( new List<Integer>{1,3} );
    // intervals.add( new List<Integer>{2,6} );
    // intervals.add( new List<Integer>{8,10} );
    // intervals.add( new List<Integer>{15,18} );
    // OutPut: ((1,6),(8,10),(15,18))

    // Example 2:
    // List<List<Integer>> intervals = new List<List<Integer>>();
    // intervals.add( new List<Integer>{1,4} );
    // intervals.add( new List<Integer>{4,5} );
    // OutPut: ((1,5))

    // Example 3:
    // List<List<Integer>> intervals = new List<List<Integer>>();
    // intervals.add( new List<Integer>{2,5} );
    // intervals.add( new List<Integer>{1,3} );
    // intervals.add( new List<Integer>{0,0} );
    //OutPut: ((0, 0), (1, 5))

    //System.debug( LcD56MergeIntervals.resolutionMerge( intervals ) );

}