/**
  * Description: class to provide Row Iterador Utility
  * author: @Eric
  * @ref.: https://salesforce.stackexchange.com/questions/85048/catch-regex-too-complicated-when-splitting-a-string-in-salesforce
  * @implementedBy Guilherme Zwipp - Everymind
  */
  public class RowIteratorUtility implements Iterator<String>, Iterable<String> {
	private String stringToSplit;
    private Integer count = 0;
    private String separationIdentifier = '\n';

    public RowIteratorUtility(String stringToSplit) {
        this.stringToSplit = stringToSplit;
    }

    public RowIteratorUtility(String stringToSplit, String rowDelimiter) {
        this.stringToSplit = stringToSplit;
        this.separationIdentifier = separationIdentifier;
    }

    public Boolean hasNext() {
        return this.count < this.stringToSplit.length() ? true : false;
    }

    public String next() {
        Integer currentIndexToSplit = this.stringToSplit.indexOf(this.separationIdentifier, this.count);

        if (currentIndexToSplit == -1)
        currentIndexToSplit = this.stringToSplit.length();

        String splittedString = this.stringToSplit.subString(this.count, currentIndexToSplit);
        this.count = currentIndexToSplit + 1;
        return splittedString;
    }

    public Iterator<String> Iterator() {
        return this;
    }

}