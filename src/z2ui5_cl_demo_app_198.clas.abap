CLASS z2ui5_cl_demo_app_198 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA product TYPE string .
    DATA quantity TYPE string .
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_198 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA temp1 TYPE z2ui5_if_types=>ty_s_event_control.
      DATA temp2 TYPE string_table.
      DATA temp3 TYPE xsdboolean.
        DATA lt_arg TYPE string_table.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      product  = 'tomato'.
      quantity = '500'.

      
      view = z2ui5_cl_xml_view=>factory( ).
      view->_generic( ns = `html` name = `style` )->_cc_plain_xml( `.my-style{ background: black !important; opacity: 0.6; color: white; }` ).
      
      CLEAR temp1.
      temp1-check_view_destroy = abap_true.
      
      CLEAR temp2.
      INSERT `$event` INTO TABLE temp2.
      
      temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
      client->view_display( view->shell(
            )->page(
                    title          = 'abap2UI5 - First Example'
                    navbuttonpress = client->_event( val = 'BACK' s_ctrl = temp1 )
                    shownavbutton = temp3
                    )->button(
                        text  = 'post'
                        press = client->_event( val = 'BUTTON_POST' t_arg = temp2 )
             )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.
        
        lt_arg = client->get( )-t_event_arg.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
