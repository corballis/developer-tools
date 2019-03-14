package sample;

public class Sample {

    /**
     * This is a method description that is long enough to exceed right margin.
     * <p>
     * Another paragraph of the description placed after blank line.
     * <p/>
     * Line with manual
     * line feed.
     *
     * @param i                  short named parameter description
     * @param longParameterName  long named parameter description
     * @param missingDescription
     * @return return description.
     * @throws XXXException description.
     * @throws YException   description.
     * @throws ZException
     * @invalidTag
     */
    public abstract String sampleMethod(int i,
                                        int longParameterName,
                                        int missingDescription) throws
            XXXException,
            YException,
            ZException;

    /**
     * One-line comment
     */
    public abstract String sampleMethod2();

    /**
     * Simple method description
     *
     * @return
     */
    public abstract String sampleMethod3();
