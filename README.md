# README
1.	Antes de iniciar validar que se tiene version de ruby 3.0.1
2.	Crear nuevo proyecto para solo api (citmedia-api)
	•	$ rails new citmedia-api --api
3.	Dar de alta sobre Gemfile las gemas que se requieren para el proyecto
	•	Cambiar sobre active record que se usara postgresql (gem 'pg')
	•	Descomentar bcrypt para uso de contraseñas seguras
	•	Descomentar rack-cors para no tener errores de conexion con el frontend
	•	Agregar doorkeeper para proteccion por token (gem 'doorkeeper', '5.3.3')
	•	Agregar cloudinary para subir imagenes a su nube (gem 'cloudinary')
	•	Agregar scout_apm para verificar sobre heroku funciones que tomen mucho tiempo (gem 'scout_apm')
	•	Agregar figaro sobre development para utilizar application.yml y dar de alta variables de entorno locales (gem 'figaro')
	•	Agregar sentry sobre produccion para registrar errores criticos sobre heroku (gem 'sentry-raven')
4.	Instalar las gemas
	•	$ bundle install
5.	Agregar sobre config/application.rb la zona horaria que se debe utilizar (config.time_zone = "Monterrey")
6.	Crear archivo config/application.yml con las variables de entorno necesarias para pruebas en local
	•	CLOUDINARY_URL: "cloudinary://266954371362987:oxfHuZPIybb664UnYH2OvTIZLI0@hl5edus3j"
	
	////// Como saco esto de cloundary?
 
7.	Editar config/database.yml para agregar a que base de datos se debe conectar
8.	Editar config/puma.rb agregar que el host default sea "0.0.0.0" (set_default_host "0.0.0.0")

	////// Que significa esto y para que sirve?	

9.	Crear modelos con sus tablas sobre base de datos
	•	Crear modelo de clinicas
	◦	$ rails g model clinic
	◦	Sobre la migracion colocar columnas que se requieren, solo el nombre (name)
	◦	Sobre el modelo agregar validacion que debe estar presente el nombre
	
	////// Cual es la diferencia entre poner null: false y validates: true?

	•	Crear modelo de usuarios
	◦	$ rails g model user
	◦	Sobre la migracion colocar columnas que se requieren (title, name, last_name, eail, password_digest, user_type, clinic)
	◦	Sobre el modelo
	▪	Agregar que se usara password seguro (has_secure_password)
	▪	Agregar la asociacion con clinicas aunque no todos los usuarios tendran una clinica asi que debe ser opcional (belongs_to :clinic, optional: true)
	▪	Agregar las asociaciones con doorkeeper ademas que se elimine todo si se destruye el usuario
	
	////// Se usa el codigo de documentacion pero dudas sobre los pasos que no se hacen en el proyecto pero si en la doc.

	▪	Agregar validaciones de columnas requeridas

	////// Se revisa con bitbucket duda si title no es requerida como tal

	▪	Agregar enums con los valores string asociados a un numero
	▪	Agregar funciones para traer el nombre completo y el tipo de usuario (futuramente para uso con agendas)

	////// Porque el user_type require de funcion si se devuelvue exactmaente el mismo valor consultado

	◦	Sobre el modelo de clinica
	▪	Agregar la asociacion con usuarios, se tendran muchos usuarios por cada clinica y se deben borrar si se destruye la clinica (has_many :users, dependent: :destroy)
	•	Crear tablas de doorkeeper (https://doorkeeper.gitbook.io/guides/ruby-on-rails/getting-started)
	◦	$ bundle exec rails generate doorkeeper:install
	◦	$ bundle exec rails generate doorkeeper:migration
	◦	Modificar el archivo de la migracion que se genero, al final descomentar las dos lineas para crear llaves foraneas sobre la tabla de usuarios "users" que sera lo que se utilice para el logueo

	////// tambien se modifica: t.references :application,    null: false
	////// como: t.references :application
	////// Porque?

	
	◦	Agregar la traduccion de doorkeeper a español es opcional, hay que buscar el archivo para agregarlo sobre config/locales
10.	Correr las migraciones
	•	$ rails db:migrate
11.	Configurar sobre config/initializers las gemas que lo requieran, si no existe crear el archivo con el nombre de la gema (se corren al iniciar el proyecto sin imporatar el nombre)
	•	Doorkeeper requiere cambios extras para usar solo contraseña sin utilizar una aplicacion asignada sobre cada usuario y la personalizacion del error cuando el token es invalido

	/////// Como saber que cambios se necesitan?

12.	Crear archivo lib/custom_token_error_response.rb
	•	module CustomTokenErrorResponse
  def status
    :unauthorized
  end

  def body
    {
      status: 401,
      message: I18n.t('invalid_login')
    }
  end
end

	////// Que hacen estas funciones?
13.	Agregar sobre Rakefile que se carguen las tareas de limpiado de tokens viejos sobre doorkeeper (Doorkeeper::Rake.load_tasks)
14.	Crear usuario de pruebas
	•	$ rails c
	•	> User.create(name: "Saul", las_name: "Torres", email: "elhappy@gmail.com", password: "123456", user_type: "admin")
15.	Probar los tokens de doorkeeper sobre postman
	•	$ rails s
	•	Generar token
	◦	POST http://localhost:3000/oauth/token
grant_type: password
email: elhappy@gmail.com
password: 123456
	•	Refrescar token
	◦	POST http://localhost:3000/oauth/token
grant_type: refresh_token
refresh_token: 000000000000
	•	Revocar token
	◦	POST http://localhost:3000/oauth/revoke
token: 000000000000
16.	Agregar sobre app/controllers/application_controller.rb que corra sentry para cuando se encuentre en produccion (heroku)
17.	Crear controlador base al que todos los controladores de la version del api estaran conectados
	•	$ rails g controller api/v1/base
	•	Cambiar en la parte superior de "ApplicationController" a "ActionController::API", para no ser heredado de application_controller, si no que base_controller sea de donde hereden, igual application_controller se ejecuta por default por eso sentry registra los errores
	•	Agregar las funciones basicas para todos los controladores de la version (set_variables, current_user y validate_user_types)
18.	Crear controlador para clinicas
	•	$ rails g controller api/v1/clinics
	•	Cambiar en la parte superior de "ApplicationController" a "Api::V1::BaseController", para heredar desde base_controller
	•	Agregar que se use token de doorkeeper (before_action :doorkeeper_authorize!)
	•	Agregar que se valide el tipo de usuario para las funciones que se requiera validacion (before_action -> { validate_user_types('admin') }, only: [])
	•	Crear los metodos requeridos sobre el controlador casi siempre se inicia con los CRUD (index, create, update, destroy)
19.	Agregar sobre config/routes.rb las rutas para clinicas
	•	Validar que ya se tiene "use_doorkeeper" dentro del archivo, se creo al ejecutar "doorkeeper:install"
	•	Crear namespace para la api usando la version
	◦	namespace :api, path: "" do
  namespace :v1 do
    # rutas
  end
end
	•	Crear rutas para clinicas, se puede usar el mapeo de resources (rutas default) o especificar directo el tipo de request (get, post, put, delete, etc.)
	◦	# Clinics
resources :clinics, only: [:index, :create, :update]

