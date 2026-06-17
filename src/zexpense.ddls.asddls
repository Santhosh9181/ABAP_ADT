@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZEXPENSE
  as select from zexpenses as _expense
  composition [0..*] of ZEXPENSE_LIST as _expenseList
{
  key exp_uuid              as ExpenseUUID,
      expense_id            as ExpenseId,
      expense_date          as ExpenseDate,
      @Semantics.amount.currencyCode: 'CurrencyKey'
      expense_total         as ExpenseTotal,
      currency_key          as CurrencyKey,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _expenseList
}
