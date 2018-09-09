-- Shelter
use Shelter;
-- create table
select * from Color;
select * from Genus;
select * from Breed;
select * from Animal;
select * from Outcome where age_month<1;



-- add foreign key
alter table Genus add constraint G_fk_breedid foreign key (Breed_ID) references Breed(Breed_ID);
alter table Breed add constraint B_fk_breedid foreign key (Breed_ID) references Genus(Breed_ID);
alter table Animal add constraint A_fk_colorid foreign key (Color_ID) references Color(Color_ID); 
alter table Animal add constraint A_fk_breedid foreign key (Breed_ID) references Breed(Breed_ID);
alter table Outcome add constraint O_fk_animalid foreign key (Animal_ID) references Animal(Animal_ID);
alter table Animal add constraint A_fk_animalid foreign key (Animal_ID) references Outcome(Animal_ID);

-- create final table
create view a1 as select A.name,A.Breed_ID,A.Color_ID,O.* from Animal A join Outcome O on A.Animal_ID=O.Animal_ID;
create view a2 as select a1.*,C.Mix,C.Color_1,C.color_2 from a1 join Color C on a1.Color_ID=C.Color_ID;
create view a3 as select a2.*,B.Mix_or_not,B.Parent_1,B.Parent_2 from a2 join Breed B on a2.Breed_ID=B.Breed_ID;
create view a4 as select a3.*,G.Animal_type,G.size from a3 join Genus G on a3.Breed_ID=G.Breed_ID;
select * from a4;

create table Final as select * from a4;
select * from Final;
select distinct(SexuponOutcome) from Final ;

-- query
select count(*),SexuponOutcome from Final group by SexuponOutcome;
-- 基本数据统计
-- 猫狗数量
select count(*),Animal_type from Final group by Animal_type;   -- 猫11134,狗1559
-- 猫狗品种
select count(*) 'sum',Breed_mix,Parent_1,Parent_2 from Final where Animal_type = "Cat" group by Breed_mix,Parent_1,Parent_2 order by count(*) desc;
select count(*) 'sum',Breed_mix,Parent_1,Parent_2 from Final where Animal_type = "Dog" group by Breed_mix,Parent_1,Parent_2 order by count(*) desc;
-- 猫狗大小
select count(*) 'sum', size from Final where Animal_type = "Cat" group by size;
select count(*) 'sum', size from Final where Animal_type = "Dog" group by size;
-- 毛色统计
select count(*) 'sum',Color_mix,Color_1,Color_2 from Final group by Color_mix,Color_1,Color_2 order by count(*) desc;
select count(*) 'sum',Color_mix,Color_1,Color_2 from Final where Animal_type = "Cat" group by Color_mix,Color_1,Color_2 order by count(*) desc;
select count(*) 'sum',Color_mix,Color_1,Color_2 from Final where Animal_type = "Dog" group by Color_mix,Color_1,Color_2 order by count(*) desc;

-- 年龄分布
select count(*) 'sum', age_month from Final group by age_month order by age_month;
select Animal_ID,age_month from Final where age_month is null; -- 18 rows
select Animal_ID,age_month from Final where age_month = 0; -- 22 rows

select count(*) 'sum', age_month from Final where Animal_type="Dog" group by age_month order by age_month;
select count(*) 'sum', age_month from Final where Animal_type="Cat" group by age_month order by age_month;

-- outcome
select count(*),Animal_Type,OutcomeType from Final group by Animal_Type,OutcomeType;

-- Outcome type与名字
select count(*) 'sum',OutcomeType from Final group by OutcomeType order by count(*) desc;
select count(*) 'sum',OutcomeType from Final where name = "" and age_month>1 group by OutcomeType order by count(*) desc;
select count(*) 'sum',OutcomeType from Final where name <> "" group by OutcomeType order by count(*) desc;

-- Outcome与时间
-- 季节，月份，节日 2013.10.1-2016.2.21
select count(*),outcome_month,outcome_date from Final where OutcomeType = "Adoption" group by outcome_month,outcome_date;
select count(*),outcome_month,outcome_date from Final where OutcomeType = "Died" group by outcome_month,outcome_date;
select count(*),outcome_month,outcome_date from Final where OutcomeType = "Euthanasia" group by outcome_month,outcome_date;
select count(*),outcome_month,outcome_date from Final where OutcomeType = "Return_to_owner" group by outcome_month,outcome_date;
select count(*),outcome_month,outcome_date from Final where OutcomeType = "Transfer" group by outcome_month,outcome_date;

select count(*),outcome_month from Final where OutcomeType = "Died" group by outcome_month;

-- 上下班时间
select count(*),outcome_hour from Final group by outcome_hour; -- 5.am-24.am，正常营业时段应为7.am-19.pm
-- 特殊时段24点峰值研究
select count(*),OutcomeType from Final where Outcome_hour=0 group by OutcomeType;
 -- 各类OutcomeType与时间的关系
select count(*),outcome_hour from Final where OutcomeType = "Adoption" group by outcome_hour;
select count(*),outcome_hour from Final where OutcomeType = "Died" group by outcome_hour;
select count(*),outcome_hour from Final where OutcomeType = "Euthanasia" group by outcome_hour;
select count(*),outcome_hour from Final where OutcomeType = "Return_to_owner" group by outcome_hour;
select count(*),outcome_hour from Final where OutcomeType = "Transfer" group by outcome_hour;

-- size和outcome的关系  --健康情况
select count(*),OutcomeType from Final where size=0 and Animal_Type="Cat" group by OutcomeType;
select count(*),OutcomeType from Final where size=1 group by OutcomeType;
select count(*),OutcomeType from Final where size=2 group by OutcomeType;
select count(*),OutcomeType from Final where size=3 group by OutcomeType;

select count(*),OutcomeType,size,Animal_Type from Final group by OutcomeType,size,Animal_Type;

select count(*),size from Final where Animal_Type="Dog" group by size;

select count(*),size from Final where OutcomeType="Euthanasia" group by size;
select count(*),size from Final where OutcomeType="Died" group by size;  -- 数据没有意义，size=2的样本数量远大于其他size
-- 收养偏好
select count(*),size from Final where OutcomeType="Adoption" group by size;
select count(*),size from Final group by size;
-- 阉割与否与outcome关系
select count(*),OutcomeType from Final where SexuponOutcome="Spayed Female" group by OutcomeType;
select count(*),OutcomeType from Final where SexuponOutcome="Neutered Male" group by OutcomeType;
select count(*),OutcomeType from Final where SexuponOutcome="Intact Female" group by OutcomeType;
select count(*),OutcomeType from Final where SexuponOutcome="Intact Male" group by OutcomeType;
select count(*),OutcomeType from Final where SexuponOutcome="Unknown" group by OutcomeType;

select count(*),OutcomeType,SexuponOutcome from Final group by OutcomeType,SexuponOutcome;




select animal_type, SexuponOutcome, count(animal_type) from Final where SexuponOutcome = 'Unknown' and age_month >= 0 and age_month <= 2 group by animal_type;
select animal_type,SexuponOutcome,count(*) from Final ;



-- sex统计
select count(*),Animal_Type,SexuponOutcome from Final group by Animal_Type,SexuponOutcome;

-- 杂交统计
select count(*),Breed_mix,Animal_Type,OutcomeType from Final group by Breed_mix,Animal_Type,OutcomeType;


-- adpotion统计
select count(*),Breed_ID from Final group by Breed_ID; 
select count(*),Breed_ID from Final where OutcomeType="Adoption" group by Breed_ID;


-- 不用outcome的年龄分布


-- color与adoption
select count(*),Color_mix,Animal_Type from Final where OutcomeType = "Adoption" group by Color_mix,Animal_Type;

select * from Final where Animal_Type="Cat" and Color_mix=3;

create view adoption as select * from Final where OutcomeType = "Adoption";

create view cc1 as select count(*) sum1,Color_mix,Color_1,Color_2,Color_ID from adoption where Animal_Type="Cat" group by Color_mix,Color_1,Color_2,Color_ID;
create view cc2 as select count(*) sum2,Color_ID from Final where Animal_Type="Cat" group by Color_ID;
select cc1.*,cc2.sum2 from cc1 join cc2 on cc1.Color_ID=cc2.Color_ID;

create view dc1 as select count(*) sum1,Color_mix,Color_1,Color_2,Color_ID from adoption where Animal_Type="Dog" group by Color_mix,Color_1,Color_2,Color_ID;
create view dc2 as select count(*) sum2,Color_ID from Final where Animal_Type="Dog" group by Color_ID;
select dc1.*,dc2.sum2 from dc1 join dc2 on dc1.Color_ID=dc2.Color_ID;

select count(*),Color_mix,Animal_Type from Final group by Color_mix,Animal_Type;

select count(*),OutcomeType,Animal_Type from Final where age_month>=0 and age_month<=2 group by OutcomeType,Animal_Type;