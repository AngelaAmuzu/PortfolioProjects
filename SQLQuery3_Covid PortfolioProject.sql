SELECT*
FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 3,4


--select*
--from PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4


-- SELECT Data that we are going to be using 

select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Looking at Total Cases vs Total Deaths

select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Cases vs Population

select Location, date,  Population, total_cases, (Total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where continent is not null
----Where location like '%Ghana%'
order by 1,2


--Looking at Countries with highest infection rate compared to population 


select Location, Population, MAX(total_cases) as HighestInfectionCount, Max(Total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where continent is not null
----Where location like '%Ghana%'
Group by Location, Population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population


select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
----Where location like '%Ghana%'
Group by Location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT (For Visualization)

select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
----Where location like '%Ghana%'
Group by Location
order by TotalDeathCount desc


select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
----Where location like '%Ghana%'
Group by continent
order by TotalDeathCount desc


--Showing continents with the highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
----Where location like '%Ghana%'
Group by continent
order by TotalDeathCount desc



--Global Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast( new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2


--Joining the two files 

select*
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date


	--Looking at Total Population vs Vaccinations


	--USE CTE

With PopvsVac (Continent, location, date, populations, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY DEA.LOCATION, DEA.DATE) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/populations)*100
from popvsvac



--TEM TABLE
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY DEA.LOCATION, DEA.DATE) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null
--order by 2,3

select*, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY DEA.LOCATION, DEA.DATE) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3


select *
from #PercentPopulationVaccinated
