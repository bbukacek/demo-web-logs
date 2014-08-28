package com.hortonworks.demo.dataloader;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class DataLoader {
	
	static final Logger logger = LogManager.getLogger(DataLoader.class);
	
	int delay = 1000;
	String input = "/home/bbukacek/input";
	String output = "/home/bbukacek/output";
	String domain = "hortonworks.com";
	
	public DataLoader(){
		Properties props = new Properties();
		
		try {
			props.load(DataLoader.class.getClassLoader().getResourceAsStream("demo.properties"));
			delay = Integer.valueOf(props.getProperty("demo.delay"));
			input = props.getProperty("demo.input");
			output = props.getProperty("demo.output");
			domain = props.getProperty("demo.domain");
		} catch (FileNotFoundException e) {
			logger.error("File Not Found!");
		} catch (IOException e) {
			logger.error("Error!");
		}
	}
	
	public void loadData(){
		BufferedReader reader = null;
		FileInputStream file = null;
		FileWriter writer = null;
		String ln = "";
		
		try {
			file = new FileInputStream(input);
			writer = new FileWriter(output);
			reader = new BufferedReader(new InputStreamReader(file));
			
			while((ln = reader.readLine()) != null){
				//delay the output
				Thread.sleep(delay);
				
				
				SimpleDateFormat frmt = new SimpleDateFormat("dd/MMM/yyyy:HH:mm:ss Z");
				Date date = new Date(System.currentTimeMillis());
				
				ln = ln.replaceAll("www.onoaam.com", domain);
			
				ln = ln.replaceAll("\\[([\\w:/]+\\s[+\\-]\\d{4})\\]", "[" + frmt.format(date) + "]");
				
				
				System.out.println(ln);
				writer.write(ln +"\n");
				writer.flush();
			}
		
		} catch (IOException e) {
			logger.catching(e);
		} catch (InterruptedException e) {
			logger.catching(e);
		} 
		finally {
			try {
				reader.close();
				file.close();
			} catch (IOException e) {
				logger.catching(e);
			}
			
		}
	}
	
	public static void main(String[] args) {
		DataLoader dl = new DataLoader();
		dl.loadData();
	}

}
