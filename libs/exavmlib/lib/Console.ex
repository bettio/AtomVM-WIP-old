#
# This file is part of AtomVM.
#
# Copyright 2018-2020 Davide Bettio <davide@uninstall.it>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0 OR LGPL-2.1-or-later
#

defmodule Console do
  def puts(device \\ :stdio, item) do
    pid =
      case :erlang.whereis(device) do
        :undefined ->
          case device do
            :stdio ->
              new_pid = :erlang.open_port({:spawn, "console"}, [])
              :erlang.register(:stdio, new_pid)
              new_pid

            _ ->
              :error
          end

        pid ->
          pid
      end

    write(pid, item)
  end

  defp write(console, string) do
    send(console, {self(), string})

    receive do
      return_status ->
        return_status
    end
  end
end
