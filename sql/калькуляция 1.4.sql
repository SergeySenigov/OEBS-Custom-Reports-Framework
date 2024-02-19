-- ��� ���������� � ����������� ���������
SELECT DISTINCT cak.cost_allocation_keyflex_id, cak.concatenated_segments,
                DECODE (cak.segment1, NULL, 'null', cak.segment1) "��������",
                DECODE (cak.segment2, NULL, 'null', cak.segment2) "����",
                DECODE (cak.segment3, NULL, 'null', cak.segment3) "����� ������",
                DECODE (cak.segment4, NULL, 'null', cak.segment4) "����.������",
                DECODE (cak.segment5, NULL, 'null', cak.segment5) "��",
                decode(pc.DEBIT_OR_CREDIT, 'C','��', 'D','��') "��\��"
           FROM pay_payroll_actions ppa,
                pay_assignment_actions paa,
                pay_cost_allocation_keyflex cak,
                pay_costs pc
          WHERE 1=1
            and ppa.payroll_id = 62                                 -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
            AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011',
                                                    'dd.mm.yyyy')
                                       AND TO_DATE ('31.01.2011',
                                                    'dd.mm.yyyy')
            AND paa.payroll_action_id = ppa.payroll_action_id
            AND pc.assignment_action_id = paa.assignment_action_id
            AND cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id

-- ����� �� ����� ���������������� ������
-- ��� �������� �������� � ����� �� ���
SELECT SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 0, 'D', 1)
           ) "debet",
       SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 1, 'D', 0)
           ) "kredit"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and cak.segment1 = '10'
   and cak.segment2 = '000000'
   and cak.segment3 = '0000000'
   and cak.segment4 = '000000000'
   and cak.segment5 = '00'
    
-- � ���� ���� ����� �� ����� ���������������� ������
SELECT paaf.ASSIGNMENT_number "�����", 
       papf.full_name "���",
       pet.ELEMENT_NAME "�������",
( select pet_d.element_name 
    from pay_input_values_f piv_d,
         pay_element_types_f pet_d
          where 1=1
            AND pc.distributed_input_value_id = piv_d.input_value_id
            AND pet_d.element_type_id = piv_d.element_type_id
            AND TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN pet_d.effective_start_date
                                       AND pet_d.effective_end_date
            AND TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN piv_d.effective_start_date
                                       AND piv_d.effective_end_date
       ) "������� ����",
       decode(pc.DEBIT_OR_CREDIT, 'C','��', 'D','��') "��\��", 
       pc.costed_value "C����"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf,
       pay_input_values_f piv,
       pay_element_types_f pet,
       per_all_people_f papf
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   AND pc.input_value_id = piv.input_value_id
   AND pet.element_type_id = piv.element_type_id
   AND ppa.effective_date BETWEEN pet.effective_start_date
                              AND pet.effective_end_date
   AND ppa.effective_date BETWEEN piv.effective_start_date
                              AND piv.effective_end_date
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and cak.segment1 = '10'
   and cak.segment2 = '000000'
   and cak.segment3 = '0000000'
   and cak.segment4 = '000000000'
   and cak.segment5 = '00'
 --  and pc.debit_or_credit = 'D'    -- ����� ����� ��� ������
   and papf.person_id = paaf.person_id
   and ppa.EFFECTIVE_DATE between papf.effective_start_date  and papf.effective_end_date

-- ��� �������� �������� � ����� �� ���
SELECT cak.segment3 "����� ������", SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 0, 'D', 1)
           ) "��",
       SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 1, 'D', 0)
           ) "��"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and pc.transfer_to_gl_flag = 'Y'
 group by cak.segment3  

-- ��� �������� �������� � ����� �� ��� (� ������ "�����" �� �����)
SELECT cak.segment3 "���", SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 0, 'D', 1)
           ) "��",
       SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 1, 'D', 0)
           ) "��"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf
     , pay_input_values_f piv
     , PAY_ELEMENT_LINKS_F pel 
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
  -- and pc.transfer_to_gl_flag = 'Y'
   and nvl(pc.distributed_input_value_id, pc.input_value_id) = piv.input_value_id
   AND ppa.effective_date BETWEEN piv.effective_start_date
                                       AND piv.effective_end_date
   and piv.element_type_id =  pel.element_type_id
   and nvl(pel.payroll_id, 62) = 62  --paaf.payroll_id
   and ppa.effective_date BETWEEN pel.effective_start_date
                                       AND pel.effective_end_date
   and pel.transfer_to_gl_flag = 'Y'                                    
 group by cak.segment3 
 
 
-- ����� � ���������� � �������
select tbl.a1 "���", 
(select pet.ELEMENT_NAME
   from pay_element_types_f pet
  where pet.element_type_id = tbl.a2
    and TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN pet.effective_start_date
                                                 AND pet.effective_end_date ) "�������",
( select pet_d.element_name 
    from pay_input_values_f piv_d,
         pay_element_types_f pet_d
          where 1=1
            AND tbl.a5 = piv_d.input_value_id
            AND pet_d.element_type_id = piv_d.element_type_id
            AND TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN pet_d.effective_start_date
                                       AND pet_d.effective_end_date
            AND TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN piv_d.effective_start_date
                                       AND piv_d.effective_end_date
       ) "������� ����",                                                         
tbl.a3 "��\��", 
tbl.a4 "C����" 
  from (
SELECT cak.segment3 a1,  -- "���"
       piv.element_type_id a2, -- "�������",
       decode(pc.DEBIT_OR_CREDIT, 'C','��', 'D','��') a3,  -- "��\��", 
       SUM(pc.costed_value) a4, -- "C����"
       pc.distributed_input_value_id a5
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf,
       pay_input_values_f piv
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   AND pc.input_value_id = piv.input_value_id
   AND ppa.effective_date BETWEEN piv.effective_start_date
                              AND piv.effective_end_date
 --  and pc.transfer_to_gl_flag = 'Y'
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and cak.segment3 = '3211000'
  group by cak.segment3, piv.element_type_id, pc.DEBIT_OR_CREDIT, pc.distributed_input_value_id ) tbl 
     
-- ����� � ���������� � ������� (� ������ �������) 
select tbl.a1 "���", 
(select pet.ELEMENT_NAME
   from pay_element_types_f pet
  where pet.element_type_id = tbl.a2
    and TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN pet.effective_start_date
                                                 AND pet.effective_end_date ) "�������",
( select pet_d.element_name 
    from pay_input_values_f piv_d,
         pay_element_types_f pet_d
          where 1=1
            AND tbl.a5 = piv_d.input_value_id
            AND pet_d.element_type_id = piv_d.element_type_id
            AND TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN pet_d.effective_start_date
                                       AND pet_d.effective_end_date
            AND TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN piv_d.effective_start_date
                                       AND piv_d.effective_end_date
       ) "������� ����",                                                         
tbl.a3 "��\��", 
tbl.a4 "C����",
--a6 "ID InV",
  (select pel.transfer_to_gl_flag
     from pay_input_values_f piv_2
        , PAY_ELEMENT_LINKS_F pel 
    where 1=1
      and nvl(a5, a6) = piv_2.input_value_id
      AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')  BETWEEN piv_2.effective_start_date
                                           AND piv_2.effective_end_date
      and piv_2.element_type_id =  pel.element_type_id
      and nvl(pel.payroll_id, 62) = 62  --paaf.payroll_id
      and TO_DATE ('31.01.2011', 'dd.mm.yyyy') BETWEEN pel.effective_start_date
                                       AND pel.effective_end_date ) "������� � ��"

  from (
SELECT cak.segment3 a1,  -- "���"
       piv.element_type_id a2, -- "�������",
       decode(pc.DEBIT_OR_CREDIT, 'C','��', 'D','��') a3,  -- "��\��", 
       SUM(pc.costed_value) a4, -- "C����"
       pc.distributed_input_value_id a5,
       pc.input_value_id a6
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf,
       pay_input_values_f piv
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   AND pc.input_value_id = piv.input_value_id
   AND ppa.effective_date BETWEEN piv.effective_start_date
                              AND piv.effective_end_date
 --  and pc.transfer_to_gl_flag = 'Y'
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and cak.segment3 = '3211100'
  group by cak.segment3, piv.element_type_id, pc.DEBIT_OR_CREDIT, pc.distributed_input_value_id, pc.input_value_id) tbl 
          
-- ���� � ����������, ����������������� �� ������������ �������� �������� (� �������)
SELECT paaf.ASSIGNMENT_number "�����", 
       papf.full_name "���", 
       pet.ELEMENT_NAME "�������",
       ( select pet_d.element_name 
           from pay_input_values_f piv_d,
                pay_element_types_f pet_d
          where 1=1
            AND pc.distributed_input_value_id = piv_d.input_value_id
            AND pet_d.element_type_id = piv_d.element_type_id
            AND ppa.effective_date BETWEEN pet_d.effective_start_date
                                       AND pet_d.effective_end_date
            AND ppa.effective_date BETWEEN piv_d.effective_start_date
                                       AND piv_d.effective_end_date
       ) "������� ����",        
       cak.segment3 "����� ������", 
       decode(pc.DEBIT_OR_CREDIT, 'C','��', 'D','��') "��\��", 
       pc.costed_value "C����"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf,
       pay_input_values_f piv,
       pay_element_types_f pet,
       per_all_people_f papf
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   AND pc.input_value_id = piv.input_value_id
   AND pet.element_type_id = piv.element_type_id
   AND ppa.effective_date BETWEEN pet.effective_start_date
                              AND pet.effective_end_date
   AND ppa.effective_date BETWEEN piv.effective_start_date
                              AND piv.effective_end_date
   and pc.transfer_to_gl_flag = 'Y'
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   AND cak.segment3 = '3122300'    -- �������� �������� 
   and pc.debit_or_credit = 'C'    -- ����� ����� ��� ������
   and papf.person_id = paaf.person_id
   and ppa.EFFECTIVE_DATE between papf.effective_start_date  and papf.effective_end_date
 
   
-- ��� ���� � �������������
select papf.full_name, paaf.ASSIGNMENT_NUMBER,
       ( select st.USER_STATUS
           from PER_ASSIGNMENT_STATUS_TYPES st
          where st.assignment_status_type_id = paaf.assignment_status_type_id ) "������",
       paaf.effective_start_date, paaf.effective_end_date, ou.NAME
  from PER_ALL_ASSIGNMENTS_F paaf
     , per_all_people_f papf 
     , hr_all_organization_units ou
 where 1=1
   and papf.person_id = paaf.person_id
   and to_date('31.01.2011','dd.mm.yyyy') between papf.effective_start_date  
                                              and papf.effective_end_date
   and to_date('31.01.2011','dd.mm.yyyy') BETWEEN paaf.effective_start_date   
                                              AND paaf.effective_end_date
   and paaf.organization_id = ou.organization_id    
   and ou.NAME = '�� - ������ ��������'                     
   
 -- ���������� ������� �� ��������
SELECT pet.ELEMENT_NAME, paaf.assignment_number, papf.full_name, piv.NAME, prrv.result_value
 FROM  pay_payroll_actions ppa,
       pay_assignment_actions paa,
       PAY_RUN_RESULTS     prr,
       PAY_RUN_RESULT_VALUES prrv,
       PAY_ELEMENT_TYPES_F pet,
       PAY_INPUT_VALUES_F piv,
       per_all_assignments_f paaf,
       per_all_people_f papf 
where 1=1 
  and ppa.EFFECTIVE_DATE between to_date('01.01.2011','dd.mm.yyyy') and to_date('31.01.2011','dd.mm.yyyy')
  and  ppa.ACTION_TYPE in ('R', 'Q')
  and  paa.payroll_action_id = ppa.payroll_action_id
  and  prr.assignment_action_id = paa.assignment_action_id
  and  prrv.run_result_id = prr.run_result_id
  and  pet.element_type_id = prr.element_type_id
  and  ppa.EFFECTIVE_DATE between pet.EFFECTIVE_START_DATE and pet.EFFECTIVE_END_DATE
  and  piv.input_value_id = prrv.input_value_id
  and  ppa.EFFECTIVE_DATE between piv.EFFECTIVE_START_DATE and piv.EFFECTIVE_END_DATE
  and ( piv.NAME = '�������� �������' or piv.NAME = 'Pay Value')
  and pet.ELEMENT_NAME like '������%����%' -- ���� �������� ������ �������
  and paaf.assignment_id = paa.assignment_id
  and ppa.EFFECTIVE_DATE between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
  and papf.person_id = paaf.person_id
  and ppa.EFFECTIVE_DATE between papf.effective_start_date  and papf.effective_end_date
   
--��� �����("�������") ��������� ��������, �������  ����������� �� ������������ ��� ������������� �������� (������ ���������)  
SELECT pet.ELEMENT_NAME,
       cak.segment3 "���",  
       paaf.assignment_number,
       decode(pc.DEBIT_OR_CREDIT, 'C','��', 'D','��')  "��\��", 
       pc.costed_value "C����",
       pet_d.ELEMENT_NAME "�����. ��-�"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf,
       pay_input_values_f piv
      ,pay_element_types_f pet
      ,pay_input_values_f piv_d
      ,pay_element_types_f pet_d 
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   AND pc.input_value_id = piv.input_value_id
   AND ppa.effective_date BETWEEN piv.effective_start_date
                              AND piv.effective_end_date
   and pet.element_type_id = piv.element_type_id
   and ppa.effective_date BETWEEN pet.effective_start_date
                              AND pet.effective_end_date                              
   and pc.transfer_to_gl_flag = 'Y'
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and pc.distributed_input_value_id = piv_d.input_value_id
   AND ppa.effective_date BETWEEN piv_d.effective_start_date
                              AND piv_d.effective_end_date
   AND pet_d.element_type_id = piv_d.element_type_id
   AND ppa.effective_date BETWEEN pet_d.effective_start_date
                              AND pet_d.effective_end_date
   and pet.ELEMENT_NAME = '������ ������� ������������'  
 --  and cak.segment3 = ''
------------------------------------------------------------------------------
--- ��������� �����������-----------------------------------------------------
------------------------------------------------------------------------------
-- ��������� 
  select pap.PAYROLL_NAME, 
         pap.payroll_id,
         DECODE (cak.segment1, NULL, 'null', cak.segment1) "��������",
         DECODE (cak.segment2, NULL, 'null', cak.segment2) "����",
         DECODE (cak.segment3, NULL, 'null', cak.segment3) "����� ������",
         DECODE (cak.segment4, NULL, 'null', cak.segment4) "����.������",
         DECODE (cak.segment5, NULL, 'null', cak.segment5) "��",
         DECODE (cak_p.segment1, NULL, 'null', cak_p.segment1) "�������� (���)",
         DECODE (cak_p.segment2, NULL, 'null', cak_p.segment2) "����(���)",
         DECODE (cak_p.segment3, NULL, 'null', cak_p.segment3) "����� ������(���)",
         DECODE (cak_p.segment4, NULL, 'null', cak_p.segment4) "����.������(���)",
         DECODE (cak_p.segment5, NULL, 'null', cak_p.segment5) "��(���)"
    from PAY_ALL_PAYROLLS_F pap
       , PAY_COST_ALLOCATION_KEYFLEX cak
       , PAY_COST_ALLOCATION_KEYFLEX cak_p
   where 1 = 1 
     and to_date('31.01.2011','dd.mm.yyyy') between pap.EFFECTIVE_START_DATE and pap.EFFECTIVE_END_DATE
     and pap.COST_ALLOCATION_KEYFLEX_ID = cak.COST_ALLOCATION_KEYFLEX_ID
     and pap.SUSPENSE_ACCOUNT_KEYFLEX_ID = cak_p.COST_ALLOCATION_KEYFLEX_ID
                                  
-- �����
  select pap.PAYROLL_NAME "���������",  pet.ELEMENT_NAME "�������", 
         pectl.classification_name "�������������",
         decode(links.COSTABLE_TYPE,'D','�������������','F','����.�������','N','��� ������','C','�������', '������') "��� ������",
         decode(cak.CONCATENATED_SEGMENTS, null, 'null',cak.CONCATENATED_SEGMENTS) "�����������", 
         decode(cak.SEGMENT1, null, 'null',cak.SEGMENT1) "��������",
         decode(cak.SEGMENT2, null, 'null',cak.SEGMENT2) "����",
         decode(cak.SEGMENT3, null, 'null',cak.SEGMENT3) "����� ������",
         decode(cak.SEGMENT4, null, 'null',cak.SEGMENT4) "����.������",
         decode(cak.SEGMENT5, null, 'null',cak.SEGMENT5) "��",
         cak_p.CONCATENATED_SEGMENTS "��������.c���", 
         cak_p.SEGMENT1 "��������",
         cak_p.SEGMENT2 "����",
         cak_p.SEGMENT3 "����� ������",
         cak_p.SEGMENT4 "����.������",
         cak_p.SEGMENT5 "��" ,
         decode (links.transfer_to_gl_flag, 'Y', '��','N','���')      
    from PAY_ELEMENT_LINKS_F links
       , PAY_ELEMENT_TYPES_F pet
       , PAY_COST_ALLOCATION_KEYFLEX cak
       , PAY_COST_ALLOCATION_KEYFLEX cak_p
       , PAY_ALL_PAYROLLS_F pap
       , pay_element_classifications pec
       , pay_element_classifications_tl pectl
   where 1=1
     and links.COST_ALLOCATION_KEYFLEX_ID = cak.COST_ALLOCATION_KEYFLEX_ID(+)
     and pet.ELEMENT_TYPE_ID = links.ELEMENT_TYPE_ID
     and links.BALANCING_KEYFLEX_ID = cak_p.COST_ALLOCATION_KEYFLEX_ID(+)  
     and to_date('31.01.2011','dd.mm.yyyy') between links.EFFECTIVE_START_DATE and links.EFFECTIVE_END_DATE
     and pap.payroll_id(+) = links.payroll_id
     and to_date('31.01.2011','dd.mm.yyyy') between pap.EFFECTIVE_START_DATE(+) and pap.EFFECTIVE_END_DATE(+)
     AND pet.classification_id = pec.classification_id
     AND pec.classification_id = pectl.classification_id
     AND nvl(pectl.LANGUAGE,'RU') = 'RU'
--     and UPPER(pet.ELEMENT_NAME) not like '% �������������%' 
   order by pet.ELEMENT_NAME  
     
-- �����������
select ou.DATE_FROM, ou.DATE_TO, ou.NAME, 
         cak.SEGMENT3 "��� ��"
    from HR_ORGANIZATION_UNITS ou
       , PAY_COST_ALLOCATION_KEYFLEX cak
       , hr_organization_information oi
   where 1=1
     and ou.DATE_FROM <= to_date('31.01.2011','dd.mm.yyyy')
     and nvl(ou.DATE_TO, to_date('01.01.2011','dd.mm.yyyy')) >= to_date('01.01.2011','dd.mm.yyyy')
     and ou.COST_ALLOCATION_KEYFLEX_ID = cak.COST_ALLOCATION_KEYFLEX_ID(+)
     and oi.ORGANIZATION_ID = ou.ORGANIZATION_ID
     and oi.ORG_INFORMATION_CONTEXT = 'CLASS'
     and oi.ORG_INFORMATION1 = 'HR_ORG'    -- ����������� ���
    order by ou.NAME 
           
---------------------------------------------------------------

-- ������� � ��, ����� �� ������������� (gl_interface)
select SEGMENT1 "��������",
       SEGMENT2 "����",
       SEGMENT3 "����� ������",
       SEGMENT4 "����.������",
       SEGMENT5 "��",
       sum(ENTERED_DR), sum(ENTERED_CR)
  from gl_interface
 where USER_JE_CATEGORY_NAME = '��������'
   and trunc(ACCOUNTING_DATE,'mm') = to_date('01.01.2011','dd.mm.yyyy')
  group by SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5 
 order by SEGMENT2

-- ������� � ��, ����� �� ������������� (pay_costs)
SELECT cak.SEGMENT1 "��������",
       cak.SEGMENT2 "����",
       cak.SEGMENT3 "����� ������",
       cak.SEGMENT4 "����.������",
       cak.SEGMENT5 "��", 
       SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 0, 'D', 1)
           ) "debet",
       SUM (pc.costed_value * DECODE (pc.debit_or_credit, 'C', 1, 'D', 0)
           ) "kredit"
  FROM hr.pay_cost_allocation_keyflex cak,
       hr.pay_costs pc,
       pay_assignment_actions paa,
       pay_payroll_actions ppa,
       per_all_assignments_f paaf
 WHERE 1=1
   and cak.cost_allocation_keyflex_id = pc.cost_allocation_keyflex_id
   AND pc.assignment_action_id = paa.assignment_action_id
   AND paa.payroll_action_id = ppa.payroll_action_id
   AND ppa.effective_date BETWEEN TO_DATE ('01.01.2011', 'dd.mm.yyyy')
                              AND TO_DATE ('31.01.2011', 'dd.mm.yyyy')
   AND paaf.assignment_id = paa.assignment_id
   AND ppa.effective_date BETWEEN paaf.effective_start_date
                              AND paaf.effective_end_date
   and paaf.payroll_id = 62                -- 62 - ��������, 61 - ������������, 65 - ����������, 63 - ��������
   and pc.transfer_to_gl_flag = 'Y'
  group by cak.SEGMENT1, cak.SEGMENT2, cak.SEGMENT3, cak.SEGMENT4, cak.SEGMENT5 

     

