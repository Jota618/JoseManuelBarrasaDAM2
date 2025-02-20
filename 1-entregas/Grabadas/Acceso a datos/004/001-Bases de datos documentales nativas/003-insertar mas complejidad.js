db.clientes.insertOne(
	{
		nombre:"Jose Vicente",
		apellidos:"Carratala Sanchis",
		correos:[
			{	
				tipo:'personal',
				correo:'info@josevicentecarratala.com'
			},{	
				tipo:'trabajo',
				correo:'info@jocarsa.com'
			}]
	}
)
