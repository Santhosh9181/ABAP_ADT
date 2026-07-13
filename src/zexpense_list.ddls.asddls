@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense List'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZEXPENSE_LIST
  as select from zexpenses_list
  association to parent ZEXPENSE as _expense on $projection.ExpenseUUID = _expense.ExpenseUUID
{
  key expenselist_uuid      as ExpenselistUuid,
      expense_uuid          as ExpenseUUID,
//      expense_id            as ExpenseId,
      expenselist_id        as ExpenselistId,
      expense_type          as ExpenseType,
      @Semantics.amount.currencyCode: 'CurrencyKey'
      expense_amount        as ExpenseAmount,
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
      _expense
}
