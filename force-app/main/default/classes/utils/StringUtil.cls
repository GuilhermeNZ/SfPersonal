public class StringUtil {
    public static List<String> extractFieldsCSVConverter(String input) {
        List<String> results = new List<String>();

        Pattern pattern = Pattern.compile('_([a-zA-Z]+)\\s');
        Matcher matchers = pattern.matcher(input);

        while (matchers.find()) {
            results.add(matchers.group(1));
        }
        
        return results;
    }
}