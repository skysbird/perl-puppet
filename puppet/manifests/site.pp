import "modules.pp"
import "default_groups.pp"
#import "nodes.pp"
import "temp/*.pp"

node default{
	include default_groups
}
