SELECT *
FROM PortFolio..coviddeath
Where location is not null
ORDER BY 3,4

--SELECT *
--FROM PortFolio..covidvaccination
--ORDER BY 3,4

--Select Data that we are going to be using 

Select location,Date,total_cases,new_cases,total_deaths,population
From PortFolio..coviddeath
Where location is not null
Order by 2,3

--looking atTotal Cases vs Total Deaths

Select location,Date,population ,total_cases, (total_cases/population)*100 as DeathPercentage
From PortFolio..coviddeath
Where location like '%state%'
and continent is not null
order by 1,2

--looking at Countries with Highest infection Rate compared to Population
 
 Select location,population ,Max(total_cases)as Highestinfectioncount, Max(total_cases/population)*10 as Percentpopulationinfected
From PortFolio..coviddeath
Where location is not null
Group by  location,population 
order by Percentpopulationinfected desc


--Showing Countries with Highest Death Count per Population
 Select location,population ,Max(cast(Total_deaths as int)) as TotalDeathCount
From PortFolio..coviddeath
--Where location like '%state%'
Where location is not null
Group by  location,population 
order by TotalDeathCount desc 

--LET'S BREAK THINGS DOWN BY CONTINENT

SeleCT continent,Max(cast(Total_deaths as int)) as TotalDeathCount
From PortFolio..coviddeath
--Where location like '%state%'
Where continent is not null
Group by  continent
order by TotalDeathCount desc 

--Showing  continent with the highest death count per population
SeleCT continent,Max(cast(Total_deaths as int)) as TotalDeathCount
From PortFolio..coviddeath
--Where location like '%state%'
Where continent is not null
Group by  continent
order by TotalDeathCount desc 

--Global Numbers
Select Date,population ,total_cases, (total_cases/population)*100 as DeathPercentage
From PortFolio..coviddeath
Where location like '%state%'
and continent is not null
Group by Date
order by 1,2

--Looking at Total population vs vaccination


Select dea.continent,dea.date, dea.location, dea.population ,vac. new_vaccinations
,SUM(Cast( vac. new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location
,dea.Date) as RollingPoepleVaccinated
FROM POrtfolio..Coviddeath dea
join PortFolio..covidvaccination vac
    On dea.location =vac.location
	and dea.date=vac.date
Where  dea.continent is not null
and vac.new_vaccinations is not null
Order by 1,2
 