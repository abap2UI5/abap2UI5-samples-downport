CLASS Z2UI5_CL_DEMO_APP_075 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA mv_path TYPE string.
    DATA mv_value TYPE string.
    DATA mr_table TYPE REF TO data.
    DATA mv_check_edit TYPE abap_bool.
    DATA mv_check_download TYPE abap_bool.

    DATA mv_file TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS ui5_on_init.
    METHODS ui5_on_event.

    METHODS ui5_view_main_display.

    METHODS ui5_view_init_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_075 IMPLEMENTATION.


  METHOD ui5_on_event.
            DATA lv_dummy TYPE string.
            DATA lv_data TYPE string.
            DATA lv_data2 TYPE xstring.
        DATA x TYPE REF TO cx_root.
    TRY.

        CASE client->get( )-event.

          WHEN 'START' OR 'CHANGE'.
            ui5_view_main_display( ).

          WHEN 'UPLOAD'.

            
            
            SPLIT mv_value AT `;` INTO lv_dummy lv_data.
            SPLIT lv_data AT `,` INTO lv_dummy lv_data.

            
            lv_data2 = z2ui5_cl_util=>conv_decode_x_base64( lv_data ).
            mv_file = z2ui5_cl_util=>conv_get_string_by_xstring( lv_data2 ).

            client->message_box_display( `CSV loaded to table` ).

            ui5_view_main_display( ).

            CLEAR mv_value.
            CLEAR mv_path.

          WHEN 'BACK'.
            client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

        ENDCASE.

        
      CATCH cx_root INTO x.
        client->message_box_display( text = x->get_text( ) type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD ui5_on_init.

    ui5_view_init_display( ).

  ENDMETHOD.


  METHOD ui5_view_init_display.

      ui5_view_main_display( ).

*    client->view_display( Z2UI5_cl_xml_view=>factory( client
*         )->_z2ui5( )->timer(  client->_event( `START` )
*         )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_file_uploader=>get_js( )
*         )->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_view_main_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA footer TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell( )->page(
            title          = 'abap2UI5 - Upload Files'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp1
        )->header_content(
            )->toolbar_spacer(
            )->link( text = 'Source_Code' target = '_blank'
        )->get_parent( ).

    IF mv_file IS NOT INITIAL.

      page->code_editor(
          value    = client->_bind( mv_file )
          editable = abap_false
      ).

    ENDIF.

    
    footer = page->footer( )->overflow_toolbar( ).

    footer->_z2ui5( )->file_uploader(
      value       = client->_bind_edit( mv_value )
      path        = client->_bind_edit( mv_path )
      placeholder = 'filepath here...'
      upload      = client->_event( 'UPLOAD' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_on_init( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_main_display( ).
    ENDIF.

    ui5_on_event( ).

  ENDMETHOD.
ENDCLASS.
