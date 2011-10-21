module ServerTools

  #
  # Creates the complete path passed and puts a message to the console.
  #
  def create_directory(path)
    puts "Create directory\t#{path}"
    FileUtils.mkpath(path)
  end

  #
  # Picks a file and replaces contained placeholders with the values from the
  # hash placeholders_with_values.
  # The resulting content gets then written to target.
  #
  def customize_file(source, target, placeholders_with_values)
    puts "Customize file\t\t#{source} -> #{target}"

    content = File.read(source)
    placeholders_with_values.keys.each do |placeholder|
      content = content.gsub(/\{#{placeholder}\}/, placeholders_with_values[placeholder])
    end

    File.open(target, "w") do |f| f.puts content end
  end

  #
  # Deletes a file and puts a message to the console.
  #
  def delete_file(file)
    puts "Delete file/\t#{file}"
    FileUtils.remove(file)
  end

  #
  # Creates a symlink from source to target and puts a message to the console.
  #
  def create_symlink(source, target)
    puts "Create symlink\t\t#{source} -> #{target}"
    FileUtils.symlink(source, target)
  end
  
end