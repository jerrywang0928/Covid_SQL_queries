--Preview CovidDeaths
SELECT
  *
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 ORDER BY
  3,
  4
 LIMIT
  1000;
--Preview CovidVaccination
SELECT 
    * FROM `covid-portfolio-338320.covid_portfolio.CovidVaccination`
    order by 3, 4
    LIMIT 1000;

-- Select Data that we are going to be using
SELECT
  Location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 ORDER BY
  1,2;
-- Looking at Total Cases vs Total Deaths in US
SELECT
  Location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  round((total_deaths/total_cases)*100,2) as DeathPercentage
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 WHERE
  location like '%States%'
 ORDER BY 1,2;
-- Looking at Total Cases vs Population
SELECT
  Location,
  date,
  population
  total_cases,
  new_cases,
  total_deaths,
  round((total_cases/population)*100,2) as DeathPercentage
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 WHERE
  location like '%States%'
 ORDER BY 1,2;

-- Looking at Countries with Highest Infection Rate Compared to Population
SELECT
  Location,
  population,
  max(total_cases) as Highest_InfectionCount,
  round(max((total_cases/population)*100),2) as Percent_Population_Infected
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 GROUP BY location, population
 ORDER BY Percent_Population_Infected desc; 

-- Showing Countries with Highest Death Count per Population
SELECT
  Location,
  max(total_deaths) as Total_Death_Count,
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 WHERE continent is not null
 GROUP BY location
 ORDER BY Total_Death_Count desc; 

-- Let's break things down by continent
-- Showing continents with the highest death count per population
SELECT
  continent,
  max(total_deaths) as Total_Death_Count,
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 WHERE continent is not null
 GROUP BY continent
 ORDER BY Total_Death_Count desc; 

-- Global Numbers
SELECT
  SUM(new_cases) as total_cases, 
  SUM(cast(new_deaths as int)) as total_deaths, 
  SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
 FROM
  `covid-portfolio-338320.covid_portfolio.CovidDeaths`
 WHERE continent is not null
 --GROUP BY date
 ORDER BY 1,2; 

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT 
 V.continent,
 V.location,
 V.date,
 D.population,
 V.new_vaccinations,
 sum(V.new_vaccinations) over(partition by V.location order by V.location, V.date) AS RollingPeopleVaccinated
 FROM `covid-portfolio-338320.covid_portfolio.CovidVaccination` AS V
 JOIN  `covid-portfolio-338320.covid_portfolio.CovidDeaths` AS D ON V.location = D.location AND V.date = D.date
 WHERE V.continent is not null 
 ORDER BY 2,3; 

--Use CTE
With Pop_vs_Vac
as
(
  SELECT 
 V.continent,
 V.location,
 V.date,
 D.population,
 V.new_vaccinations,
 sum(V.new_vaccinations) over(partition by V.location order by V.location, V.date) AS RollingPeopleVaccinated
 FROM `covid-portfolio-338320.covid_portfolio.CovidVaccination` AS V
 JOIN  `covid-portfolio-338320.covid_portfolio.CovidDeaths` AS D ON V.location = D.location AND V.date = D.date
 WHERE V.continent is not null 
 ORDER BY 2,3 
)

Select *, round((RollingPeopleVaccinated/Population)*100,2) as Vaccination_Percentage
From Pop_vs_Vac;

-- Creating View to store data for later visualizations
Create View Percent_Population_Vaccinated as
SELECT 
 V.continent,
 V.location,
 V.date,
 D.population,
 V.new_vaccinations,
 sum(V.new_vaccinations) over(partition by V.location order by V.location, V.date) AS RollingPeopleVaccinated
 FROM `covid-portfolio-338320.covid_portfolio.CovidVaccination` AS V
 JOIN  `covid-portfolio-338320.covid_portfolio.CovidDeaths` AS D ON V.location = D.location AND V.date = D.date
 WHERE V.continent is not null;




