select * from covid_deaths;
use portfolio;
select * from covid_vaccinations;
drop table if exists covid_deaths;
select * from covid_deaths;
select location, date, total_cases, new_cases, total_deaths, population from covid_deaths;
select location, date, total_cases, total_deaths,
((total_deaths/total_cases)*100) as deathpercentage from covid_deaths
where location like '%Nigeria%';
select location, date, total_cases, population, ((total_cases/population)*100) 
as infection_rate from covid_deaths where location like '%Nigeria%';
select location, max(total_cases) as highest_infection_no, 
population, (max(total_cases/population)*100) 
as infection_rate from covid_deaths
group by location, population order by infection_rate desc;
select location, max(cast(total_deaths as float)) as total_death_count
from covid_deaths
where continent <> ''
group by location
order by total_death_count desc;
select * from covid_deaths;
select * from covid_deaths;
select location, max(cast(total_deaths as float)) as total_death_count
from covid_deaths
where continent <> ''
group by location
order by total_death_count desc;
select continent, max(cast(total_deaths as float)) as total_death_count
from covid_deaths
where continent <> ''
group by continent
order by total_death_count desc;
select location, max(cast(total_deaths as float)) as total_death_count
from covid_deaths
where continent <> ''
group by location
order by total_death_count desc; 
select date, sum(new_cases) as total_daily_cases,
 sum(cast(new_deaths as float)) as total_daily_deaths,
 (sum(cast(new_deaths as float))/sum(new_cases) * 100) as daily_death_rate
from covid_deaths
where continent <> ''
group by date
order by total_daily_cases desc;
select sum(new_cases) as total_daily_cases,
 sum(cast(new_deaths as float)) as total_daily_deaths,
 (sum(cast(new_deaths as float))/sum(new_cases) * 100) as daily_death_rate
from covid_deaths
where continent <> ''
order by total_daily_cases desc;
select * from covid_vaccinations;
select * from covid_deaths dea 
join 
covid_vaccinations vac 
on dea.location = vac.location
and dea.date = vac.date;

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from covid_deaths dea join covid_vaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ' '
order by vac.new_vaccinations desc;
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location 
order by dea.location, dea.date) as rolling_people_vaccinated
from covid_deaths dea join covid_vaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ' '
order  by dea.location, dea.date;
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location 
order by dea.location, dea.date) as rolling_people_vaccinated
from covid_deaths dea join covid_vaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ' '
order  by dea.location, dea.date;

with pop_vaccinated(continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as (select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location 
order by dea.location, dea.date) as rolling_people_vaccinated
from covid_deaths dea join covid_vaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ' '
order  by dea.location, dea.date)
select *, (rolling_people_vaccinated/population) *100 as percentage_vac from pop_vaccinated;

drop table if exists percentpopvac;
create temporary table percentpopvac(
continent varchar(255),
location nvarchar(255),
date nchar(255),
population numeric,
new_vaccinations float,
rolling_people_vaccinated numeric
);
insert into percentpopvac(
select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as float),
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location 
order by dea.location, dea.date) as rolling_people_vaccinated
from covid_deaths dea join covid_vaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ' ');
/*order  by dea.location, dea.date*/
select *, (rolling_people_vaccinated/population) *100 as percentage_vac from percentpopvac;



