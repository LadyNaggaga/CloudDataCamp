CREATE TABLE [dbo].[AvgReadings] (
	    [WinStartTime]   DATETIME2 (6) NULL,
	    [WinEndTime]     DATETIME2 (6) NULL,
	    [Type]     VarChar(50) NULL,
	    [RoomNumber]     VarChar(10) NULL,
	    [Avgreading] FLOAT (53)    NULL,
	    [EventCount] BIGINT null
	);
	
	GO
	CREATE CLUSTERED INDEX [AvgReadings]
	ON [dbo].[AvgReadings]([RoomNumber] ASC);