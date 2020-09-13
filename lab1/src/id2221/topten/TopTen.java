package id2221.topten;

import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;
import java.util.HashMap;
import java.util.Collections;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.mapreduce.TableMapper;
import org.apache.hadoop.hbase.mapreduce.TableReducer;
import org.apache.hadoop.hbase.mapreduce.TableMapReduceUtil;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.filter.FirstKeyOnlyFilter;

public class TopTen {
    // This helper function parses the stackoverflow into a Map for us.
    public static Map<String, String> transformXmlToMap(String xml) {
        Map<String, String> map = new HashMap<String, String>();
        try {
            String[] tokens = xml.trim().substring(5, xml.trim().length() - 3).split("\"");
            for (int i = 0; i < tokens.length - 1; i += 2) {
                String key = tokens[i].trim(); // Omitts string with no leading and trailing spaces
                String val = tokens[i + 1];
                map.put(key.substring(0, key.length() - 1), val);
            }
        } catch (StringIndexOutOfBoundsException e) {
            System.err.println(xml);
        }

        return map;
    }

    public static class TopTenMapper extends Mapper<Object, Text, NullWritable, Text> {
        // A TreeMap is a subclass of Map that sorts on key
        // Stores a map of user reputation to the record (id?)
        TreeMap<Integer, Text> repToRecordMap = new TreeMap<Integer, Text>(Collections.reverseOrder());

        // The mappers should filter their input split to the top ten records
        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {

            // <FILL IN>

            // value will be one line in the xml file
            Map<String, String> dataMap = TopTen.transformXmlToMap(value.toString());

            if (!dataMap.containsKey("Id") || !dataMap.containsKey("Reputation")) {
                return;
            }

            // Would replace any record with the same reputation as another record:
            repToRecordMap.put(Integer.parseInt(dataMap.get("Reputation")), new Text(dataMap.get("Id")));

            // Avoid having too many entries in TreeMap
            // if (repToRecordMap.size() > 10) {
            //     repToRecordMap.pollLastEntry();
            // }

        }

        // cleanup() gets called once after all key-value pairs have been through the
        // map function
        protected void cleanup(Context context) throws IOException, InterruptedException {
            // After all the records have been processed, the top ten records in the
            // TreeMap are output to the reducers in the cleanup method.

            // Output our ten records to the reducers with a null key
            // <FILL IN>

            System.out.println("repToRecordMap.size(): " + repToRecordMap.size());

            int count = 0;
            for (Map.Entry<Integer, Text> pair : repToRecordMap.entrySet()) {
                if (count >= 10)
                    break;

                // Expected org.apache.hadoop.hbase.io.ImmutableBytesWritable, received
                // org.apache.hadoop.io.NullWritable
                context.write(NullWritable.get(), pair.getValue());

                // context.write(pair.getKey(), new ImmutableBytesWritable(pair.getValue()));

                // Reputation could be null, but not ID

                // context.write(new Text(pair.getValue()), new NullWritable(pair.getKey()));
                // context.write(new NullWritable(pair.getKey()), new Text(pair.getValue()));
                count++;
            }
        }
    }

    public static class TopTenReducer extends TableReducer<NullWritable, Text, NullWritable> {
        // Stores a map of user reputation to the record
        private TreeMap<Integer, Text> repToRecordMap = new TreeMap<Integer, Text>();

        public void reduce(NullWritable key, Iterable<Text> values, Context context)
                throws IOException, InterruptedException {
            // <FILL IN>
            // columns rep and id should be created in your Java code

            try {
                int count = 0;
                System.out.println("key: " + key);
                for (Text val : values) {
                    System.out.println("val: " + val);

                    // create hbase put with rowkey as date
                    Put insHBase = new Put(Bytes.toBytes(count));

                    // insert sum value to hbase
                    insHBase.addColumn(Bytes.toBytes("info"), Bytes.toBytes("id"), val.getBytes());

                    // write data to Hbase table
                    context.write(null, insHBase);
                    count++;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) throws Exception {
        // <FILL IN>
        // Configuration conf = new Configuration();
        Configuration conf = HBaseConfiguration.create();

        Job job = Job.getInstance(conf);
        job.setJarByClass(TopTen.class);

        job.setMapperClass(TopTenMapper.class);
        // job.setCombinerClass(TopTenReducer.class);
        // job.setReducerClass(TopTenReducer.class);

        job.setMapOutputKeyClass(NullWritable.class);
        job.setMapOutputValueClass(Text.class);

        // define output table
        TableMapReduceUtil.initTableReducerJob("topten", TopTenReducer.class, job);

        job.setNumReduceTasks(1);

        FileInputFormat.addInputPath(job, new Path(args[0]));

        job.waitForCompletion(true);
    }
}
