-- Follow Along Project with Alex the Analyst on Youtube

Select * 
From PortfolioProject..['Covid Deaths$'] 
Where continent is not null 
Order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['Covid Deaths$']
Where location like '%states%'
and continent is not null 
Order by 1,2

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..['Covid Deaths$']
Where location like '%states%'
and continent is not null 
Order by 1,2

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
Group by location, population
Order by PercentPopulationInfected desc


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
Group by location
Order by TotalDeathCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
Group by continent
Order by TotalDeathCount desc



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
Order by 1,2


With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['Covid Vaccinations$'] vac
Join PortfolioProject..['Covid Deaths$'] dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
 )

 Select *, (RollingPeopleVaccinated/Population)*100 as PercentVaccinated
 From PopvsVac



 Drop table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric,
 )

 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['Covid Vaccinations$'] vac
Join PortfolioProject..['Covid Deaths$'] dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['Covid Vaccinations$'] vac
Join PortfolioProject..['Covid Deaths$'] dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
