select pp.employee_number "Таб номер", pp.full_name "ФИО", pp.date_of_birth "Дата рождения", 
       decode(adr.town_or_city, null, 
              reg1.name || ' ' || reg1.abbrev || ', ' || reg2.name || ' ' || reg2.abbrev || ', ' || reg3.abbrev  || ' ' ||
              reg3.name, town.abbrev || '. ' || town.name) || ', ' || street.abbrev || '. ' || street.name || ' ' || 
              adr.address_line2 || adr.address_line3 || ' - ' || adr.telephone_number_1 "Адрес",
       esb_reports_common.get_org_wide_name(asg.organization_id) "Подразделение",
       NVL(asg.ass_attribute4, pd.segment2) "Должность", oterr.name "Филиал" 

from per_all_assignments_f asg, per_all_people_f pp, PER_ADDRESSES adr, 
     PER_RU_ADDRESS_LOOKUPS reg1,  --region_1
     PER_RU_ADDRESS_LOOKUPS reg2,  --region_2
     PER_RU_ADDRESS_LOOKUPS reg3,  --region_3    
     PER_RU_ADDRESS_LOOKUPS town,  --town_or_city
     per_ru_street_lookups street,  --address_line1 
     hr_all_positions_f pos,
     per_position_definitions pd,
     hr_all_organization_units oterr
          
where sysdate between asg.effective_start_date and asg.effective_end_date
and sysdate between pp.effective_start_date and pp.effective_end_date
and sysdate between pos.effective_start_date and pos.effective_end_date
and sysdate between NVL(adr.date_from (+) , sysdate) and NVL(adr.date_to (+), sysdate) 
and adr.region_1 = reg1.kladr_code (+)  || reg1.kladr_code_s (+)
and adr.region_2 = reg2.kladr_code (+)  || reg2.kladr_code_s (+)
and adr.region_3 = reg3.kladr_code (+)  || reg3.kladr_code_s (+)
and adr.town_or_city = town.kladr_code (+)  || town.kladr_code_s (+)
and adr.address_line1 = street.kladr_code (+)  || street.kladr_code_s (+)
and asg.person_id = adr.person_id (+)
--and adr.primary_flag (+) = 'Y'
and asg.person_id = pp.person_id
and asg.position_id = pos.position_id
and esb_reports_common.get_org_terr_category(asg.organization_id) = oterr.organization_id (+)
and pd.position_definition_id = pos.position_definition_id
and asg.business_group_id = 0
and asg.assignment_status_type_id in (1,99)
and asg.people_group_id in (62,65) 
and asg.assignment_type = 'E'
and asg.primary_flag = 'Y'
and adr.address_type (+) = 'RU_R'
and asg.payroll_id <> 65
--and pp.person_id = 2097
order by pp.full_name
