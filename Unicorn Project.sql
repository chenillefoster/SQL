Select * From PortfolioProject..Unicorn_Companies$


-- Find Companies with Greatest Return on Investment

Select Company, [Valuation Extended], [Funding Extended], [valuation extended]-[funding extended] as "Return on Investment"
From PortfolioProject..Unicorn_Companies$
Order by "Return on Investment" desc


-- Find Time Took to Become a Unicorn

Select Company, [Year Joined], [Year Founded],[Year Joined]-[Year Founded] as "Years Elapsed"
From PortfolioProject..Unicorn_Companies$
Order by "Years Elapsed" asc

Select AVG([Year Joined]-[Year Founded]) as "Average Years Elapsed"
From PortfolioProject..Unicorn_Companies$

Select Company, [Year Joined], [Year Founded], AVG([Year Joined]-[Year Founded])
	Over (Order by [Year Founded]
			Rows between 3 preceding and 3 following) SevenYearMovAvg
From PortfolioProject..Unicorn_Companies$


-- Find where the Unicorn Companies are Located

Select Continent, Count(Company) as "Companies"
From PortfolioProject..Unicorn_Companies$
Group By Continent
Order by "Companies" desc

Select Country, Count(Company) as "Companies"
From PortfolioProject..Unicorn_Companies$
Group By Country
Order by "Companies" desc

Select City, Country, Continent, Count(Company) as "Companies"
From PortfolioProject..Unicorn_Companies$
Where City is not null
Group By City,Country, Continent
Order by "Companies" desc

Select City, Country, Industry, Count(Company) as "Companies"
From PortfolioProject..Unicorn_Companies$
Where City is not null
Group By City,Country,Industry
Order by "Companies" desc


-- Find Investors with the Most Unicorns

Create view Investor_1 AS
Select Count([Investor 1 Trimmed]) as "count 1", [Investor 1 Trimmed]
From PortfolioProject..Unicorn_Companies$
Where [Investor 1 Trimmed] is not null AND [Investor 1 Trimmed]!=''
Group by [Investor 1 Trimmed]

Create view Investor_2 AS
Select Count([Investor 2 Trimmed]) as "count 2", [Investor 2 Trimmed]
From PortfolioProject..Unicorn_Companies$
Where [Investor 2 Trimmed] is not null AND [Investor 2 Trimmed]!=''
Group by [Investor 2 Trimmed]

Create view Investor_3 AS
Select Count([Investor 3 Trimmed]) as "count 3", [Investor 3 Trimmed]
From PortfolioProject..Unicorn_Companies$
Where [Investor 3 Trimmed] is not null AND [Investor 3 Trimmed]!=''
Group by [Investor 3 Trimmed]

Create view Investor_4 AS
Select Count([Investor 4 Trimmed]) as "count 4", [Investor 4 Trimmed]
From PortfolioProject..Unicorn_Companies$
Where [Investor 4 Trimmed] is not null AND [Investor 4 Trimmed]!=''
Group by [Investor 4 Trimmed]

Create view Investor_Totals AS
Select coalesce([Investor 1 Trimmed],[Investor 2 Trimmed],[Investor 3 Trimmed],[Investor 4 Trimmed]) As Investor, IsNull([Count 1], 0)+IsNull([Count 2],0)+IsNull([Count 3],0)+IsNull([Count 4],0) as "Total Count"
From Investor_1 a
Full Join Investor_2 b
On a.[Investor 1 Trimmed] = b.[Investor 2 Trimmed]
Full Join Investor_3 c
On a.[Investor 1 Trimmed] = c.[Investor 3 Trimmed]
Full Join Investor_4 d
On a.[Investor 1 Trimmed] = d.[Investor 4 Trimmed]

Select * From Investor_Totals
Order by [Total Count] desc


