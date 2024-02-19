 -- ��� ���������� ��������
 select paaf.effective_start_date, paaf.effective_end_date,
        st.USER_STATUS "������", 
		paaf.assignment_status_type_id asg_status_id, 
        paaf.*
  from PER_ALL_ASSIGNMENTS_F paaf
     , per_all_people_f papf 
     , PER_ASSIGNMENT_STATUS_TYPES st
 where to_date('31.12.2007','dd.mm.yyyy') BETWEEN paaf.effective_start_date   -- ������ �� ������ ����
                                              AND paaf.effective_end_date
   and papf.full_name like '%���������%%'                                           
   and papf.person_id = paaf.person_id
   and paaf.assignment_status_type_id = st.assignment_status_type_id
   and paaf.effective_start_date between papf.effective_start_date  
                            and papf.effective_end_date
order by paaf.assignment_id, paaf.effective_start_date

  -- ����� � ��������    
   select paaf.assignment_id,  papf.full_name, 
        ppp.change_date "����� � ����", 
        ppp.proposed_salary_n "����� � ����", 
		ppb.name "������", 
        ou.name "�����������"
   from per_all_assignments_f paaf,
        per_all_people_f papf,
        per_pay_proposals ppp,
        PER_PAY_BASES ppb,
        HR_ALL_ORGANIZATION_UNITS ou
  where to_date('31.12.2007','dd.mm.yyyy') between paaf.effective_start_date and paaf.effective_end_date
    and papf.person_id = paaf.person_id
    and to_date('31.12.2007','dd.mm.yyyy') between papf.effective_start_date  and papf.effective_end_date
    and ppp.assignment_id = paaf.assignment_id
    and ppb.pay_basis_id = paaf.pay_basis_id
    and paaf.organization_id = ou.organization_id
    and ppp.change_date = 
        ( select max(ppp_1.change_date) 
            from per_pay_proposals ppp_1
           where ppp_1.assignment_id = ppp.assignment_id
  		     and to_date('31.12.2007','dd.mm.yyyy') >= change_date) 
    and papf.full_name like '%%���������%%'
   order by 1,2,3,4
   
       -- ���������� ���������� (����� ���������� ������)
    select  ppf.full_name "���", sl.DATE_FROM, sl.DATE_TO, 
	        ptp.period_name, sl.SICK_LIST_ID
      from RTM_SICK_LISTS sl
         , per_people_f         ppf
         , per_time_periods ptp    
     where sl.person_id = ppf.person_id
       and sl.DATE_FROM between ppf.EFFECTIVE_START_DATE and ppf.EFFECTIVE_END_DATE
       and sl.time_period_id = ptp.time_period_id
       and ppf.full_name like '%���������%'
     order by 2
     
 /* ������� ����������� - �����������*/
SELECT   paid_days "���.���", note 
    FROM rtm_sick_list_periods
   WHERE sick_list_id = 169
ORDER BY period_id

-- ������� (����� ��������)
    select  ppf.full_name "���", paaf.ASSIGNMENT_number "�", fcl.meaning "��� �������", 
	        l.LEAVE_DAYS "���", l.SPECIAL_DAYS "���", 
			l.LEAVE_FROM, l.LEAVE_RETURN, 
            l.ADVANCE_DATE "�����", paaf.ASSIGNMENT_ID, l.LEAVE_ID 
      from rtm_leaves l
         , per_people_f         ppf
         , PER_ALL_ASSIGNMENTS_F paaf
         , fnd_common_lookups fcl
     where l.assignment_id = paaf.assignment_id
       and l.LEAVE_FROM between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
       and paaf.person_id = ppf.person_id
       and l.LEAVE_FROM between ppf.EFFECTIVE_START_DATE and ppf.EFFECTIVE_END_DATE
       and ppf.full_name like '%���������%%'
       and fcl.lookup_code = l.leave_type
       and fcl.lookup_type = 'RU_LEAVE_TYPES'
     order by l.LEAVE_FROM desc   
     
    -- ������ �� ���� 
    select  ppf.full_name "���", paaf.ASSIGNMENT_number "�", wtu.USAGE_DATE, tut.mnemonic "����", wtu.usage_time/60 "�����",  
	       wtu.PROJECT_ID "������", wtu.TASK_ID "������", decode (tse.correction_date, null, '���', '���') "���/���", 
		   tse.transferted "to payroll"
     from RTM.RTM_WORK_TIME_USAGE wtu
        , RTM.RTM_TIME_USAGE_TYPES tut
        , rtm_time_sheet_elements tse
         , per_people_f         ppf
         , PER_ALL_ASSIGNMENTS_F paaf
    where wtu.usage_id = tut.usage_id
      and tse.element_id = wtu.ELEMENT_ID
      and tse.assignment_id = paaf.assignment_id
       and tse.date_from between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
       and paaf.person_id = ppf.person_id
       and tse.date_from between ppf.EFFECTIVE_START_DATE and ppf.EFFECTIVE_END_DATE
       and ppf.full_name like '%���������%%'
       and trunc(tse.date_from,'mm') = to_date('01.04.2008','dd.mm.yyyy')
     order by 2, 3
     
-- ������������� ��������
SELECT ppa.EFFECTIVE_DATE, paaf.assignment_number "�", pet.ELEMENT_NAME,  piv.NAME, prrv.result_value --, ppa.* 
 FROM  pay_payroll_actions ppa, -- papf.full_name,
       pay_assignment_actions paa,
       PAY_RUN_RESULTS     prr,
       PAY_RUN_RESULT_VALUES prrv,
       PAY_ELEMENT_TYPES_F pet,
       PAY_INPUT_VALUES_F piv,
       per_all_assignments_f paaf,
       per_all_people_f papf 
where  ppa.EFFECTIVE_DATE between to_date('01.10.2007','dd.mm.yyyy') and to_date('31.10.2007','dd.mm.yyyy')
  and  ppa.ACTION_TYPE in ( 'B')
  and  paa.payroll_action_id = ppa.payroll_action_id
  and  prr.assignment_action_id = paa.assignment_action_id
  and  prrv.run_result_id = prr.run_result_id
  and  pet.element_type_id = prr.element_type_id
  and  ppa.EFFECTIVE_DATE between pet.EFFECTIVE_START_DATE and pet.EFFECTIVE_END_DATE
  and  piv.input_value_id = prrv.input_value_id
  and  ppa.EFFECTIVE_DATE between piv.EFFECTIVE_START_DATE and piv.EFFECTIVE_END_DATE
 -- and ( piv.NAME = '�������� �������' or piv.NAME = 'Pay Value' )
  and paaf.assignment_id = paa.assignment_id
  and ppa.EFFECTIVE_DATE between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
  and papf.person_id = paaf.person_id
  and ppa.EFFECTIVE_DATE between papf.effective_start_date  and papf.effective_end_date
  and papf.full_name like '%���������%'
  order by 1, 2, 3  

select * from fnd_user
where user_id in (1159, 1466)

  
-- ���������� ������� ����������
SELECT paa.payroll_action_id, ppa.EFFECTIVE_DATE, papf.full_name, paaf.assignment_number "�", pet.ELEMENT_NAME,  piv.NAME, prrv.result_value 
 FROM  pay_payroll_actions ppa,
       pay_assignment_actions paa,
       PAY_RUN_RESULTS     prr,
       PAY_RUN_RESULT_VALUES prrv,
       PAY_ELEMENT_TYPES_F pet,
       PAY_INPUT_VALUES_F piv,
       per_all_assignments_f paaf,
       per_all_people_f papf 
where  ppa.EFFECTIVE_DATE between to_date('01.04.2008','dd.mm.yyyy') 
        and to_date('31.05.2008','dd.mm.yyyy')
  and  ppa.ACTION_TYPE in ( 'R', 'Q')
  and  paa.payroll_action_id = ppa.payroll_action_id
  and  prr.assignment_action_id = paa.assignment_action_id
  and  prrv.run_result_id = prr.run_result_id
  and  pet.element_type_id = prr.element_type_id
  and  ppa.EFFECTIVE_DATE between pet.EFFECTIVE_START_DATE and pet.EFFECTIVE_END_DATE
  and  piv.input_value_id = prrv.input_value_id
  and  ppa.EFFECTIVE_DATE between piv.EFFECTIVE_START_DATE and piv.EFFECTIVE_END_DATE
  and ( piv.NAME = '�������� �������' or piv.NAME = 'Pay Value' )
  and paaf.assignment_id = paa.assignment_id
  and ppa.EFFECTIVE_DATE between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
  and papf.person_id = paaf.person_id
  and ppa.EFFECTIVE_DATE between papf.effective_start_date  and papf.effective_end_date
  and papf.full_name like '%%���������%'
  order by paa.payroll_action_id, pet.ELEMENT_NAME
  
-- �������� �������� �� ����
 select papf.full_name, paaf.ASSIGNMENT_NUMBER, 
        Pay_Ru_Paye.get_balance (paaf.assignment_id, '���� �� ���������� �����', '_ASG_ITD', to_date('31.12.2007', 'dd.mm.yyyy')) "����"
  from PER_ALL_ASSIGNMENTS_F paaf,
        per_all_people_f papf
 where to_date('31.12.2007','dd.mm.yyyy') between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
   and papf.person_id = paaf.person_id
   and paaf.EFFECTIVE_START_DATE between papf.effective_start_date  and papf.effective_end_date
  -- and papf.full_name like '%����������, ��������� ��������%'
   and paaf.payroll_id = 83
 order by 1 
 
-- ��������� � �������. ����� �������� ��� ���������
select tat.assignment_id, tat.dat, papf.full_name
  from per_all_people_f papf,
       PER_ALL_ASSIGNMENTS_F paaf1, 
( select max(paaf.EFFECTIVE_END_DATE) dat, paaf.assignment_id, paaf.person_id
  from PER_ALL_ASSIGNMENTS_F paaf
 group by paaf.assignment_id, paaf.person_id 
 having max(paaf.EFFECTIVE_END_DATE) < to_date('31.12.4712','dd.mm.yyyy')) tat
  where 1=1
    and papf.person_id = tat.person_id
    and tat.dat between papf.effective_start_date  and papf.effective_end_date
    and paaf1.assignment_id = tat.assignment_id
    and paaf1.EFFECTIVE_END_DATE = tat.dat
    and paaf1.payroll_id = 61
    and tat.dat between to_date('01.10.2007','dd.mm.yyyy') and to_date('31.10.2007','dd.mm.yyyy')
 order by tat.dat  
 

