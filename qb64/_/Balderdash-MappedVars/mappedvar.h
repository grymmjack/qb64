#include <map>

const std::string WHITESPACE = " \n\r\t\f\v";
std::string ltrim(const std::string& s)
{
    size_t start = s.find_first_not_of(WHITESPACE);
    return (start == std::string::npos) ? "" : s.substr(start);
}
 
std::string rtrim(const std::string& s)
{
    size_t end = s.find_last_not_of(WHITESPACE);
    return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}
 
std::string trim(const std::string& s)
{
    return rtrim(ltrim(s));
}

static std::map <std::string, std::string> environment;
int mapvar(std::string name, std::string value){
  if (!name.empty() && trim(name) != ""){
	  name = trim(name);
	  environment[name] = value;
	  return 1;
  }
  else{
	  return 0;
  }
  }

const char * getmappedvalue(std::string name){
	if(environment.find(name) != environment.end()){
		return environment[name].c_str();
	}
	else{
		return "";
	}
}
void freemappedvar(std::string name){
	environment.erase(name);
}
void freemap(){
	environment.clear();
}
size_t mapsize(){
	return environment.size();
}