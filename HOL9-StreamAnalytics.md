# Hands on Lab 9 - Azure Stream Analytics #

## 1. Introduction ##

In this lab we will use Azure Stream Analytics and a tumbling window to aggregate device data and output this to a Azure SQL Database

## 2. Pre-requisites ##

- Database table created as part of HOL 1

## 3. Create the Streaming Analytics Job ##

1.  Navigate to the Microsoft Azure management interface [https://manage.windowsazure.com](https://manage.windowsazure.com) (NOTE: Azure Stream Analytics is only configurable in current Management Portal at this time)

2. Click "+NEW" in the bottom left hand corner of the screen

	![alt text](images/CreateHDInsightCluster/createHDInsightClusterImg3.png "createHDInsightClusterImg3.png")

3. Select Data Services -> Stream Analytics, click Quick Create.

	![alt text](images/StreamAnalytics/streamAnalyticsImg1.png "streamAnalyticsImg1.png")

4. Configure Stream Analytics.
	- Enter a job name and location (limited choice due to this being in preview, select any location)
	- Select **Create new storage account**.
	- Enter a new storage account name.
	
5. Click Create stream analytics job.

	![alt text](images/StreamAnalytics/streamAnalyticsImg2.png "streamAnalyticsImg2.png")

6. Once creation has finished, navigate to the job.

	![alt text](images/StreamAnalytics/streamAnalyticsImg3.png "streamAnalyticsImg3.png")

7. Select the Inputs tab.

    ![alt text](images/StreamAnalytics/streamAnalyticsImg4.png "streamAnalyticsImg4.png")

8. Click "+Add Input" at the bottom middle of the screen.

	![alt text](images/StreamAnalytics/streamAnalyticsImg5.png "streamAnalyticsImg5.png")

9. Choose the default "Data stream" click next.

    ![alt text](images/StreamAnalytics/streamAnalyticsImg6.png "streamAnalyticsImg6.png")

10. Choose the "Event Hub" option.

    ![alt text](images/StreamAnalytics/streamAnalyticsImg7.png "streamAnalyticsImg7.png")

11. Enter the connection information for the event hub, click next.
	- Input alias is **MyEventHubStream** (The name is important as it is references in the query)
	- Select **Use Event Hub from Current Subscription**

    ![alt text](images/StreamAnalytics/streamAnalyticsImg8.png "streamAnalyticsImg8.png")

12. Specify that the data serialization format is JSON and the encoding is UTF-8, click Finish

	![alt text](images/StreamAnalytics/streamAnalyticsImg9.png "streamAnalyticsImg9.png")

13. The connection to the storage account will be tested, this will take a moment to complete

    ![alt text](images/StreamAnalytics/streamAnalyticsImg10.png "streamAnalyticsImg10.png")

14. A new input will be created.

	![alt text](images/StreamAnalytics/streamAnalyticsImg11.png "streamAnalyticsImg11.png")

15. Navigate to the Output tab
 
    ![alt text](images/StreamAnalytics/streamAnalyticsImg12.png "streamAnalyticsImg12.png")

16. Click "+Input" at the bottom middle of the screen

	![alt text](images/StreamAnalytics/streamAnalyticsImg5.png "streamAnalyticsImg5.png")

17. Choose SQL Database

    ![alt text](images/StreamAnalytics/streamAnalyticsImg16.png "streamAnalyticsImg14.png")

18. Enter the connection information, click Finish.
	- Choose **Use SQL Database from Existing Subscription**
	- Select the database created in Hands on Lab 1
	- Enter the user name and password used when the database was created
	- Enter the table name **AvgReadings**
	
    ![alt text](images/StreamAnalytics/streamAnalyticsImg14.png "streamAnalyticsImg14.png")

19. A new output will be created.

	![alt text](images/StreamAnalytics/streamAnalyticsImg15.png "streamAnalyticsImg15.png")

20. On the Query tab enter the following and select **Save** at the bottom.

	```SQL
	SELECT DateAdd(minute,-1,System.TimeStamp) as WinStartTime, system.TimeStamp as WinEndTime, Type = 'Temperature', RoomNumber, Avg(Temperature) as AvgReading, Count(*) as EventCount
    	FROM MyEventHubStream
    	Where Temperature IS NOT NULL
    	GROUP BY TumblingWindow(minute, 1), RoomNumber, Type
	UNION
	SELECT DateAdd(minute,-1,System.TimeStamp) as WinStartTime, system.TimeStamp as WinEndTime, Type = 'Humidity', RoomNumber, Avg(Humidity) as AvgReading, Count(*) as EventCount
	    FROM MyEventHubStream
	    Where Humidity IS NOT NULL
	    GROUP BY TumblingWindow(minute, 1), RoomNumber, Type
	UNION
	SELECT DateAdd(minute,-1,System.TimeStamp) as WinStartTime, system.TimeStamp as WinEndTime, Type = 'Energy', RoomNumber, Avg(Kwh) as AvgReading, Count(*) as EventCount
	    FROM MyEventHubStream
	    Where Kwh IS NOT NULL
	    GROUP BY TumblingWindow(minute, 1), RoomNumber, Type
	UNION
	SELECT DateAdd(minute,-1,System.TimeStamp) as WinStartTime, system.TimeStamp as WinEndTime, Type = 'Light', RoomNumber, Avg(Lumens) as AvgReading, Count(*) as EventCount
	    FROM MyEventHubStream
	    Where Lumens IS NOT NULL
	    GROUP BY TumblingWindow(minute, 1), RoomNumber, Type
    ```
    
21. On the Dashboard tab, start the job by pressing the "Start" button on the bottom middle of the page    

    ![alt text](images/StreamAnalytics/streamAnalyticsImg17.png "streamAnalyticsImg17.png")

22. It will take a few moments to start, a minute or so later data should appear in the database table.  Use Microsoft SQL Management Studio to view the result.

	
