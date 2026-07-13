CLASS lhc_Expense DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Expense RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Expense RESULT result.

    METHODS Resume FOR MODIFY
      IMPORTING keys FOR ACTION Expense~Resume.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Expense RESULT result.
    METHODS setStatusClosed FOR MODIFY
      IMPORTING keys FOR ACTION expense~setStatusClosed RESULT result.
    METHODS GetDefaultsForCreate FOR READ
      IMPORTING keys FOR FUNCTION Expense~GetDefaultsForCreate RESULT result.
    METHODS changeDate FOR MODIFY
      IMPORTING keys FOR ACTION Expense~changeDate RESULT result.
    METHODS createEntry FOR MODIFY
      IMPORTING keys FOR ACTION Expense~createEntry.
    METHODS copyEntry FOR MODIFY
      IMPORTING keys FOR ACTION Expense~copyEntry.
    METHODS checkEntry FOR MODIFY
      IMPORTING keys FOR ACTION Expense~checkEntry RESULT result.

ENDCLASS.

CLASS lhc_Expense IMPLEMENTATION.

  METHOD get_instance_authorizations.
*  APPEND VALUE #(
*                       %update                = if_abap_behv=>auth-allowed
*                       %action-Edit           = if_abap_behv=>auth-allowed
*
*                       %delete                = if_abap_behv=>auth-allowed  ) TO result.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD Resume.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zexpense IN LOCAL MODE
    ENTITY Expense
    FIELDS ( ExpenseStatus  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_expense)
    FAILED failed.

    result = VALUE #( FOR ls_expense IN lt_expense
                         ( %tky = ls_expense-%tky
                           %assoc-_expenseList = COND #( WHEN ls_expense-ExpenseStatus EQ 'O'
                           THEN if_abap_behv=>fc-o-enabled
                           ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD setStatusClosed.

    MODIFY ENTITIES OF zexpense IN LOCAL MODE
    ENTITY Expense
    UPDATE FIELDS ( ExpenseStatus )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky ExpenseStatus = 'C' ) ).

    READ ENTITIES OF zexpense IN LOCAL MODE
  ENTITY Expense
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_expense)
  FAILED failed.

    result = VALUE #( FOR ls_expense IN lt_expense ( %tky = ls_expense-%tky %param = ls_expense  ) ).
  ENDMETHOD.

  METHOD GetDefaultsForCreate.

    INSERT INITIAL LINE INTO TABLE result
    ASSIGNING FIELD-SYMBOL(<fs_value>).

    <fs_value> = VALUE #(  %cid = keys[ 1 ]-%cid
    %param = VALUE #( Expenseid = '11' ExpenseDate = cl_abap_context_info=>get_system_date( ) ) ).

  ENDMETHOD.

  METHOD changeDate.

    MODIFY ENTITIES OF zexpense IN LOCAL MODE
    ENTITY Expense
    UPDATE FIELDS ( ExpenseDate )
    WITH VALUE #( FOR key IN keys (  %tky = key-%tky ExpenseDate = key-%param-ExpenseDate ) )
    FAILED failed
    MAPPED mapped.
    IF failed IS INITIAL.
      READ ENTITIES OF zexpense IN LOCAL MODE
      ENTITY Expense
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_expenses)
      FAILED failed.

      result = VALUE #( FOR ls_expense IN lt_expenses (  %tky = ls_expense-%tky %param = ls_expense ) ).

    ENDIF.

  ENDMETHOD.

  METHOD createEntry.
  ENDMETHOD.

  METHOD copyEntry.

    DATA : lt_expense_new     TYPE TABLE FOR CREATE zexpense\\Expense,
           lt_expenselist_new TYPE TABLE FOR CREATE zexpense\_expenseList.



    READ ENTITIES OF zexpense IN LOCAL MODE
    ENTITY Expense
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_expense)
    FAILED failed.
    IF failed IS INITIAL.

      lt_expense_new = VALUE #( ( %cid        = keys[ KEY entity %key = lt_expense[ 1 ]-%key ]-%cid
                                  %control    = VALUE #( ExpenseId     = if_abap_behv=>mk-on
                                                         ExpenseDate   = if_abap_behv=>mk-on
                                                         ExpenseStatus = if_abap_behv=>mk-on
                                                         ExpenseTotal  = if_abap_behv=>mk-on
                                                         CurrencyKey   = if_abap_behv=>mk-on
                                                        )
                                  CurrencyKey = 'INR'
                                  ExpenseDate = cl_abap_context_info=>get_system_date( )
                                  ExpenseId   = '12'
                                  ExpenseTotal = 1000
                              ) ).

      lt_expenselist_new = VALUE #( (  %cid_ref = keys[ KEY entity %key = lt_expense[ 1 ]-%key ]-%cid

                                    %target = VALUE #( ( %cid = 'AAA    '
                                                         %control = VALUE #( ExpenselistId = if_abap_behv=>mk-on
                                                                             ExpenseType = if_abap_behv=>mk-on
                                                                             ExpenseAmount = if_abap_behv=>mk-on
                                                                             CurrencyKey = if_abap_behv=>mk-on )
                                                         ExpenselistId = '10'
                                                         ExpenseType = 'Transport'
                                                         ExpenseAmount = 100
                                                         CurrencyKey = 'INR'  ) ) ) ).


      MODIFY ENTITIES OF zexpense IN LOCAL MODE
      ENTITY Expense
      CREATE FROM lt_expense_new
      CREATE BY \_expenseList
      FROM lt_expenselist_new
      MAPPED mapped
      FAILED failed
      REPORTED reported.

*AUTO FILL CID
* FIELDS ( ExpenseDate ExpenseId )
* WITH VALUE #( )


    ENDIF.


  ENDMETHOD.

  METHOD checkEntry.


  result = VALUE #( (  %cid = ''  %param = VALUE #( ExpenseDate =  cl_abap_context_info=>get_system_date( ) ) ) ).
  ENDMETHOD.

ENDCLASS.


CLASS lhc_expenselist DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ExpenseList RESULT result.

ENDCLASS.

CLASS lhc_expenselist IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zexpense IN LOCAL MODE
  ENTITY ExpenseList BY \_expense
  FIELDS ( ExpenseUUID ExpenseStatus  )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_expense)
  FAILED failed.
    IF failed IS INITIAL.
      DATA(ls_expense) = lt_expense[ 1 ].
    ENDIF.

    result = VALUE #( FOR key IN keys
                         ( %tky = key-%tky
                           %update =  COND #( WHEN ls_expense-ExpenseStatus EQ 'C'
                                              THEN if_abap_behv=>fc-o-disabled
                                              ELSE if_abap_behv=>fc-o-enabled )
                            ) ).


  ENDMETHOD.

ENDCLASS.
