#!/bin/bash
#
#######################################################################
#
# Copyright (C) 2016-2019 PDX Technologies, Inc. All Rights Reserved.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################
#
# PDX status script, check Utopia and Baap Runing state
#
#######################################################################

if [ $(ps -ef | grep -v grep | grep -i -c "utopia.*chain") -ne 0 ];then
   echo -e "\n\n\t utopia已启动... \n\n"
else
   echo -e "\n\n\t utopia已关闭... \n\n"
fi

if [ $(ps -ef | grep -v grep | grep -i -c "java.*baap") -ne 0 ];then
   echo -e "\n\n\t baap已启动... \n\n"
else
   echo -e "\n\n\t baap已关闭... \n\n"
fi
