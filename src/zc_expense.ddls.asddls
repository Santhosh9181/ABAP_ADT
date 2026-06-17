@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view Expense'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_EXPENSE provider contract transactional_query as projection on ZEXPENSE
{
    key ExpenseUUID,
    ExpenseId,
    ExpenseDate,
    @Semantics.amount.currencyCode: 'CurrencyKey'
    ExpenseTotal,
    CurrencyKey,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _expenseList : redirected to composition child ZC_EXPENSE_LIST
}
