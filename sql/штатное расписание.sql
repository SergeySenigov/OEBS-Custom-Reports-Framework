select pos.position_id, org.org_name, org.attribute1 as org_code, org.path, pd.segment2 as pos_name, 
decode(jd.segment1, 1, 'Раб', decode(jd.segment4, 1, 'Рук', 2, 'Спец', 3, 'Служ', '!!!')) as cat, 
pos.max_persons, bvals.value 
from hr_all_positions_f pos, per_position_definitions pd, per_jobs j, per_job_definitions jd,

  (
  SELECT org.organization_id, LPAD(' ', 4*(LEVEL-1)) || org.name as org_name, org.attribute1,
  SYS_CONNECT_BY_PATH(org.organization_id, '/') as path  
  from hr_all_organization_units org,
  (select ose.organization_id_child, ose.organization_id_parent
  from per_org_structure_elements_v ose, per_org_structure_versions v
  where ose.org_structure_version_id = v.org_structure_version_id
  and sysdate between v.date_from and nvl(v.date_to, sysdate)
  ) ose
  where org.organization_id = ose.organization_id_child (+)
  START WITH org.organization_id = 0
  CONNECT BY PRIOR org.organization_id = ose.organization_id_parent
  ) org,

  (
  select vg.position_id, vg.grade_id, g.name
  from per_valid_grades vg, per_grades g
  where vg.grade_id = g.grade_id
  and sysdate between vg.date_from and NVL(vg.date_to, sysdate)
  and not vg.position_id is null
  and not exists
   (select vg1.grade_id
    from per_valid_grades vg1, per_grades g1
    where vg1.grade_id = g1.grade_id
    and sysdate between vg.date_from and NVL(vg1.date_to, sysdate)
    and vg1.position_id = vg.position_id
    and to_number(g.name) < to_number(g1.name))
  ) gr,
  
  (
  select be.position_id, be.grade_id, bval.value
  from per_budgets b, per_budget_versions bver, per_budget_elements be, 
   (
    select bval.budget_element_id, bval.value
    from per_budget_values bval, per_time_periods tp
    where bval.time_period_id = tp.time_period_id
    and sysdate >= tp.start_date
    and not exists
     (
     select bval.budget_value_id
     from per_budget_values bval1, per_time_periods tp1 
     where bval1.time_period_id = tp1.time_period_id
     and bval1.budget_element_id = bval.budget_element_id 
     and tp1.start_date > tp.start_date
     ) 
   ) bval
  where b.name = 'Плановый оклад'
  and b.budget_id = bver.budget_id
  and sysdate between bver.date_from and NVL(bver.date_to, sysdate)
  and bver.budget_version_id = be.budget_version_id
  and be.budget_element_id = bval.budget_element_id  
  ) bvals

where sysdate between pos.effective_start_date and pos.effective_end_date
and pos.position_definition_id = pd.position_definition_id (+)
and pos.organization_id = org.organization_id
and pos.job_id = j.job_id (+)
and j.job_definition_id = jd.job_definition_id (+)
and pos.position_id = gr.position_id (+)
and gr.position_id = bvals.position_id (+)
and gr.grade_id = bvals.grade_id (+)
and pos.availability_status_id = 1

order by org.path, pos.position_id