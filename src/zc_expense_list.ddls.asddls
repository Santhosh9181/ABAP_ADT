@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view Expense List'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_EXPENSE_LIST as projection on ZEXPENSE_LIST
{
    key ExpenselistUuid,
    ExpenseUUID,
    ExpenseId,
    ExpenselistId,
    ExpenseType,
    @Semantics.amount.currencyCode: 'CurrencyKey'
    ExpenseAmount,
    CurrencyKey,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _expense : redirected to parent ZC_EXPENSE
}
