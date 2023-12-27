
USE	WP;

GO 

DROP DATABASE IF EXISTS WP; 

GO

/*Write an SQL statement to create a view named EmployeeProjectView that
displays EmployeeNumber, FirstName, LastName, Department, and HoursWorked
for each employee who has worked on at least one project and ProjectName of all
the projects assigned to each employee.*/

DROP VIEW IF EXISTS EmployeeProjectView;

GO
CREATE VIEW EmployeeProjectView AS 
	SELECT		E.EmployeeNumber, E.FirstName, E.LastName, P.Department, SUM(HoursWorked) AS TotalHoursWorked,P.ProjectID, P.ProjectName
	FROM		EMPLOYEE AS E JOIN ASSIGNMENT AS A 
				ON E.EmployeeNumber = A.EmployeeNumber
							  JOIN PROJECT AS P
				ON P.ProjectID = A.ProjectID
	GROUP BY	E.EmployeeNumber,P.ProjectName,E.FirstName,E.LastName, P.ProjectID,P.Department
	
GO

-- If we want to put in order--
SELECT*
FROM		EmployeeProjectView
ORDER BY	EmployeeNumber,ProjectID


/*Write a stored procedure ProjectEmpSearch that takes the project name as the
input and returns the first name, last name, and department of the employees
who have worked on the project by using EmployeeProjectView. Call the
procedure using the project name '2019 Q3 Marketing Plan'. Attach the
screenshot of the procedure call result in the report.*/

DROP PROCEDURE IF EXISTS ProjectEmpSearch;

GO

CREATE PROCEDURE ProjectEmpSearch (@ProjectName CHAR(50))

AS
SELECT	FirstName, LastName, Department,ProjectName
FROM 	EmployeeProjectView
WHERE	ProjectName = @ProjectName

GO
-- Execute Procedure
EXEC ProjectEmpSearch @ProjectName = '2019 Q3 Marketing Plan';


/*Write a function dbo.ProjectCost that takes the project name and hourly rate as
the input and returns the project labor cost (multiply the hourly rate by the total
hours worked on the project), by using EmployeeProjectView. Use an SQL
statement to call the function to display the labor cost of each project with 35.0
as the hourly rate. Give an appropriate column name to the computed results and
remove duplicate rows if applicable. Attach the screenshot of the function call
result in the report.*/

DROP FUNCTION IF EXISTS dbo.ProjectCost;

GO

CREATE FUNCTION dbo.ProjectCost 
(
	@ProjectName Char(50),
	@HourlyRate Numeric(8, 2)
)
RETURNS	Numeric(8, 2)
AS
BEGIN
	DECLARE	@ProjectLaborCost Numeric(8, 2);
		SELECT	@ProjectLaborCost = SUM(A.TotalHoursWorked * @HourlyRate)
		FROM	EmployeeProjectView AS A
		WHERE	A.ProjectName LIKE  @ProjectName  ;
	RETURN	@ProjectLaborCost;
END;

GO

-- Call the function
SELECT	DISTINCT ProjectName ,dbo.ProjectCost(ProjectName,35.0) AS ProjectLaborCost 
FROM	PROJECT






