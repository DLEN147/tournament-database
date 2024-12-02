WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET DEFINE OFF;

@?/demo/schema/tmtproject/create_user

@?/demo/schema/tmtproject/tmt_create

@?/demo/schema/tmtproject/tmt_const

@?/demo/schema/tmtproject/tmt_trig

@?/demo/schema/tmtproject/tmt_ins

PROMPT '¡Esquema TMT creado exitosamente!'; 

