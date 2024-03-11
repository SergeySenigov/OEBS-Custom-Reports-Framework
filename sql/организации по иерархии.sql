SELECT ou.organization_id, LPAD(' ',4*(LEVEL-1)) || ou.name org_name
from hr_all_organization_units ou, 
(select ose.organization_id_child, ose.organization_id_parent
from per_org_structure_elements_v ose, per_org_structure_versions v
where ose.org_structure_version_id = v.org_structure_version_id
and sysdate between v.date_from and nvl(v.date_to, sysdate)
) ose1
where ou.organization_id = ose1.organization_id_child (+)
START WITH ou.organization_id = 0
CONNECT BY PRIOR ou.organization_id = ose1.organization_id_parent
