src   = './src'
dest  = './build'
debug = true

module.exports =

  src: src

  dest: dest

  environment:
    debug: debug

  css:
    preprocessor: 'sass'

  sass:
    src: src + '/sass/*.{sass,scss}'
    dest: dest
    settings:
      sourceComments: do -> 'map' if debug
      imagePath: '/images'

  images:
    src: src + '/images/**'
    dest: dest + '/images'

  markup:
    src: src + '/htdocs/**'
    dest: dest

  jasmine:
    specs: dest + '/specs.js'

  browserSync:
    server:
      baseDir: [dest, src]
    files: [
      dest + '/**'
      '!' + dest + '/**.map' # Exclude sourcemaps
    ]

  browserify:
    debug: debug,
    # Additional file extentions to make optional
    extensions: ['.coffee', '.cson', '.yaml', '.json', '.hbs', '.dust']
    # A separate bundle will be generated for each
    # bundle config in the list below
    bundleConfigs: [
      entries: src + '/scripts/app.coffee'
      dest: dest
      outputName: 'app.js'
      vendor: false
    ,
      dest: dest
      outputName: 'infrastructure.js'
      vendor: true
    ,
      entries: src + '/scripts/head.coffee'
      dest: dest
      outputName: 'head.js'
    ,
      entries: './spec/**/*.spec.{js,coffee}'
      dest: dest
      outputName: 'specs.js'
    ]
