select cc.full_account, begin_balance_dr, begin_balance_cr, end_balance_dr, end_balance_cr, period_dr, period_cr,
(end_balance_dr - end_balance_cr) - (begin_balance_dr - begin_balance_cr) - (period_dr - period_cr) as d
from 

  (
  select xxfin.xxfin_bgl.bgl_full_account(cc.segment2) as full_account
  from gl_code_combinations cc
  where cc.segment1 = 10
  group by xxfin.xxfin_bgl.bgl_full_account(cc.segment2) 
  ) cc,

  (
  select xxfin.xxfin_bgl.bgl_full_account(cc.segment2) as full_account,
  decode(sign(Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr)), 1, Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr), 0)  begin_balance_dr,
  decode(sign(Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr)), -1, ABS(Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr)), 0)  begin_balance_cr

  from gl_balances bal, gl_code_combinations cc
  where bal.period_name = '฿อย-09'
  and bal.code_combination_id = cc.code_combination_id
  group by xxfin.xxfin_bgl.bgl_full_account(cc.segment2)
  ) begin_balance,
  
  (
  select xxfin.xxfin_bgl.bgl_full_account(cc.segment2) as full_account,
  decode(sign(Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr) + sum(bal.period_net_dr) - sum(bal.period_net_cr)), 1, Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr) + sum(bal.period_net_dr) - sum(bal.period_net_cr), 0)  end_balance_dr,
  decode(sign(Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr) + sum(bal.period_net_dr) - sum(bal.period_net_cr)), -1, ABS(Sum(bal.begin_balance_dr) - Sum(bal.begin_balance_cr) + sum(bal.period_net_dr) - sum(bal.period_net_cr)), 0)  end_balance_cr

  from gl_balances bal, gl_code_combinations cc
  where bal.period_name = '฿อย-09'
  and bal.code_combination_id = cc.code_combination_id
  group by xxfin.xxfin_bgl.bgl_full_account(cc.segment2)
  ) end_balance  ,
  
  (
  select xxfin.xxfin_bgl.bgl_full_account(cc.segment2) as full_account,
  sum(bal.period_net_dr) as period_dr,
  sum(bal.period_net_cr) as period_cr  

  from gl_balances bal, gl_code_combinations cc
  where bal.period_name = '฿อย-09'
  and bal.code_combination_id = cc.code_combination_id
  group by xxfin.xxfin_bgl.bgl_full_account(cc.segment2)
  ) obor
  
where cc.full_account = begin_balance.full_account (+)  
and cc.full_account = end_balance.full_account (+)  
and cc.full_account = obor.full_account (+)  