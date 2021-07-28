
SELECT *
FROM PortfolioProject.. CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.. CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.. CovidDeaths
ORDER BY 1,2


--Lets look at total_cases VS total_deaths in United states  
--Accurate Death rate till (7/26/2021)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.. CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2


--total_cases VS Population 
--10% US population 

SELECT location, date, total_cases, population, (total_cases/population)*100 AS CasePerPopulation
FROM PortfolioProject.. CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Highest Infection rate by population
SELECT location, population, MAX(total_cases) AS HigestInfectionCount, MAX((total_cases/population))*100 AS CasePerPopulation
FROM PortfolioProject.. CovidDeaths
GROUP BY location, population
ORDER BY CasePerPopulation DESC

--Highest Death count per population 
SELECT location, MAX(CAST(total_deaths AS INT)) AS HigestDeathCount
FROM PortfolioProject.. CovidDeaths
WHERE continent is not null
GROUP BY location 
ORDER BY HigestDeathCount DESC

--By Continent  
SELECT continent, MAX(CAST(total_deaths AS INT)) AS HigestDeathCount
FROM PortfolioProject.. CovidDeaths
WHERE continent is not null
GROUP BY continent 
ORDER BY HigestDeathCount DESC


--Global Numbers 

SELECT date, SUM(new_cases) AS total_Case, SUM(cast (new_deaths AS INT)) AS total_Death, SUM(cast (new_deaths AS INT))/SUM(New_Cases) * 100 AS DeathPercentage
FROM PortfolioProject.. CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--population VS vaccination
--CTE
with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac



   



